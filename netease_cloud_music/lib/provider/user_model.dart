import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netease_cloud_music/application.dart';
import 'package:netease_cloud_music/model/user.dart';
import 'package:netease_cloud_music/utils/navigator_util.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserModel with ChangeNotifier {
  User _user;

  User get user => _user;

  /// 初始化 User
  void initUser() {
    if (Application.sp.containsKey('user')) {
      String s = Application.sp.getString('user');
      _user = User.fromJson(json.decode(s));
    }
  }

  /// 登录
  void login(BuildContext context, String phone, String pwd) async {

    User user = await NetUtils.login(context, phone, pwd);
    if (user.code > 300) {
      Fluttertoast.showToast(msg: user.msg ?? '登录失败，请检查账号密码', gravity: ToastGravity.CENTER);
      return;
    }
    Fluttertoast.showToast(msg: '登录成功', gravity: ToastGravity.CENTER);
    _saveUserInfo(user);
    NavigatorUtil.goHomePage(context);
  }

  /// 保存用户信息到 sp
  _saveUserInfo(User user) {
    _user = user;
//    String s = json.encode(user.toJson());
//    user = User.fromJson(json.decode(s));

    Application.sp.setString('user', json.encode(user.toJson()));
  }
}