import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
Location _location = Location();
Geoflutterfire _geo = Geoflutterfire();

var userCollection = _firestore.collection("User");
var groupCollection = _firestore.collection('Groups');

void addUser(String name, String email) async {
  var doc = await _firestore.collection('User').add({});
  bool locationEnabled = await _location.serviceEnabled();
  var permissionGranted = await _location.hasPermission();
  late var location;
  if (permissionGranted == PermissionStatus.granted && locationEnabled) {
    location = await _location.getLocation();
  } else {
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    } else {
      throw Exception(
          'User cannot be created. \n Please check location settings.');
    }
  }
  await _firestore.collection('User').doc(doc.id).set({
    'UID': doc.id,
    'UserEmail': email,
    'UserName': name,
    'GroupList': [],
    'Requests': [],
    'Location': location,
  });
}

void createGroup(
    String groupName, String email, List<Map<String, String>> requested) async {
  var user1 = await _firestore
      .collection('User')
      .where('UserEmail', isEqualTo: email)
      .get();
  late String uid = '';
  late String admin = '';
  for (var data in user1.docs) {
    uid = data['UID'];
    admin = data['UserName'];
  }

  var group = await _firestore.collection('Groups').add({});
  _firestore.collection('Groups').doc(group.id).set({
    'GID': group.id,
    'GroupName': groupName,
    'Requested': requested,
    'Admin': admin,
  });

  updateUserInMembersList(group.id, uid);
  addGroupToGroupList(uid, admin, groupName, group.id);
  addMemberToGroup(admin, groupName, group.id, requested);
}

void addMemberToGroup(String admin, String groupName, String GID,
    List<Map<String, String>> requested) async {
  for (var i in requested) {
    var user = await _firestore
        .collection('User')
        .where('UserEmail', isEqualTo: i['Email'])
        .get();
    late String UID = '';
    for (var data in user.docs) {
      UID = data['UID'];
    }
    try {
      addGroupToRequests(UID, admin, groupName, GID);
    } catch (e) {
      print(e);
    }
  }
}

void addUserToRequested(String GID, String email) async {
  var groupData = await _firestore.collection('Groups').doc(GID).get();
  var key = groupData.data()!;

  List memberList = key['Requested'];
  dynamic map = {
    'Email': email,
  };
  for (var member in memberList) {
    if (member['Email'] == map['Email']) {
      throw 'Member Already requested';
    }
  }
  memberList.add(map);
  print(memberList);
  groupCollection.doc(GID).update({
    'Requested': memberList,
  });
}

void updateUserInMembersList(String GID, String UID) async {
  var user = await userCollection.doc(UID).get();
  var userData = user.data()!;
  List location = userData['Location'];
  String email = userData['UserEmail'];
  String name = userData['UserName'];

  GeoFirePoint point =
      _geo.point(latitude: location[0], longitude: location[1]);

  var groupData =
      _firestore.collection('Groups').doc(GID).collection('MembersList');

  dynamic map = {
    'Email': email,
    'Name': name,
    'Location': point.data,
    'UID': UID,
  };
  late String Id;
  var getData = await groupData.get();
  var data = getData.docs.where((element) => element['Email'] == map['Email']);
  if (data.isEmpty) {
    var doc = await groupData.add({});
    map['MID'] = doc.id;
    groupData.doc(doc.id).set(map);
  } else {
    for (var i in data) {
      Id = i['MID'];
    }
    map['MID'] = Id;
    groupData.doc(Id).set(map);
  }
}

void removeUserFromMembersList(String GID, String UID) async {
  var membersList =
      _firestore.collection('Groups').doc(GID).collection('MembersList');
  late String id;
  var getData = await membersList.get();
  var data = getData.docs.where((element) => element['UID'] == UID);
  if (data.isEmpty) {
    return;
  } else {
    for (var i in data) {
      id = i['MID'];
    }
    membersList.doc(id).delete();
  }
}

void addGroupToGroupList(
    String UID, String admin, String groupName, String GID) async {
  var userData = await userCollection.doc(UID).get();
  var keys = userData.data()!;
  List groupList = keys['GroupList'];

  dynamic map = {
    'Admin': admin,
    'GID': GID,
    'GroupName': groupName,
  };
  for (var group in groupList) {
    if (group['GID'] == map['GID']) {
      // throw 'Group Already Exists';
      return;
    }
  }
  groupList.add(map);
  // print(groupList);
  userCollection.doc(UID).update({
    'GroupList': groupList,
  });
}

void addGroupToRequests(
    String UID, String admin, String groupName, String GID) async {
  var userData = await _firestore.collection('User').doc(UID).get();
  var keys = userData.data()!;
  List requests = keys['Requests'];
  dynamic map = {
    'Admin': admin,
    'GID': GID,
    'GroupName': groupName,
  };
  for (var group in requests) {
    if (group['GID'] == map['GID']) {
      // throw 'Group Already Exists';
      return;
    }
  }
  requests.add(map);
  // print(requests);
  _firestore.collection("User").doc(UID).update({
    'Requests': requests,
  });
}

dynamic userIDandName(String email) async {
  late String UID;
  late String name;
  var user = await _firestore
      .collection('User')
      .where('Email', isEqualTo: email)
      .get();
  for (var data in user.docs) {
    UID = data['UID'];
    name = data['UserName'];
  }
  Map<String, String> map = {};
  map['UID'] = UID;
  map['UserName'] = name;
  return map;
}

void deleteFromRequest(String GID, String UID, String email) async {
  var user = await userCollection.doc(UID).get();
  var userData = user.data()!;

  List request = userData['Requests'];
  request.removeWhere((element) => element['GID'] == GID);
  userCollection.doc(UID).update({
    'Requests': request,
  });

  var group = await groupCollection.doc(GID).get();
  var groupData = group.data()!;

  List requested = groupData['Requested'];
  requested.removeWhere((element) => element['Email'] == email);
  groupCollection.doc(GID).update({
    'Requested': requested,
  });
}

void updateLocationInGroup(String gid, String email, GeoFirePoint pos) async {
  var memberData = await groupCollection
      .doc(gid)
      .collection('MembersList')
      .where('Email', isEqualTo: email)
      .get();
  late String mid;
  dynamic map = {
    'Email': email,
    'Location': pos.data,
  };
  for (var data in memberData.docs) {
    map['Name'] = data['Name'];
    map['UID'] = data['UID'];
    mid = data['MID'];
  }
  map['MID'] = mid;
  groupCollection.doc(gid).collection('MembersList').doc(mid).set(map);
}
