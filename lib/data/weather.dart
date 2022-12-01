import 'package:http/http.dart' as http_pk;
import 'dart:convert'; // jsonDcode 사용 가능

class Network{

  late final String url; // 날씨정보
  late final String url2; // 미세먼지(기상정보)

  // 생성자 : 앞 loading 코드에서 보낸 주소를 받습니다.
  Network(this.url, this.url2);

  Future<dynamic> getJsonData() async{
    http_pk.Response response = await http_pk.get(Uri.parse(url));

    if(response.statusCode == 200) {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData);

      return parsingData;
    } else{
      // 예외상황 처리
    }
  } // ...getJsonData()

  Future<dynamic> getAirData() async{
    http_pk.Response response = await http_pk.get(Uri.parse(url2));
    if(response.statusCode == 200) {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData);

      return parsingData;
    } else{
      // 예외상황 처리
    }
  } // ...getAirData()

}