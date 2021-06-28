/*
 * BSD 3-Clause License

    Copyright (c) 2020, RAY OKAAH - MailTo: ray@flutterengineer.com, Twitter: Rayscode
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabaseServiceProvider {
  static LocalDatabaseService get db =>
      kIsWeb ? LocalDatabaseServiceWeb() : LocalDatabaseServiceNative();
}

abstract class LocalDatabaseService {
  final _tokenKey = 'token';

  Future<void> updateSecurityToken(String? token);

  Future<void> deleteSecurityToken();

  Future<String> getSecurityToken();
}

class LocalDatabaseServiceNative extends LocalDatabaseService {
  final securityToken = new FlutterSecureStorage();

  @override
  Future<void> deleteSecurityToken() async {
    await securityToken.delete(key: this._tokenKey);
  }

  @override
  Future<String> getSecurityToken() async {
    String? token = await securityToken.read(key: this._tokenKey);
    if (token == null) {
      token = '0';
    }
    return token;
  }

  @override
  Future<void> updateSecurityToken(String? token) async {
    await securityToken.write(key: this._tokenKey, value: token);
  }
}

class LocalDatabaseServiceWeb extends LocalDatabaseService {
  @override
  Future<void> deleteSecurityToken() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(this._tokenKey);
  }

  @override
  Future<String> getSecurityToken() async {
    var prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(this._tokenKey);
    if (token == null) {
      token = '0';
    }
    return token;
  }

  @override
  Future<void> updateSecurityToken(String? token) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(this._tokenKey, token!);
  }
}
