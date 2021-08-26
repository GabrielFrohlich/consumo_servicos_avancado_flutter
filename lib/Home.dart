import 'package:consumo_servicos_avancado/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com/";

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(Uri.parse(_urlBase + 'posts'));
    var dadosJson = json.decode(response.body);
    List<Post> postagens = [];

    for (var post in dadosJson) {
      print("post: $post['title']");

      Post p = Post(post['userId'], post['id'], post['title'], post['body']);
      postagens.add(p);
    }

    print(postagens);
    return postagens;
  }

  _post() async {
    http.Response response = await http.post(Uri.parse(_urlBase + 'posts'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'title': 'foo', 'body': 'bar', 'userId': 1}));

    print(response.statusCode);
    print(response.body);
  }

  _put() async {
    http.Response response = await http.post(Uri.parse(_urlBase + 'post/1'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'title': 'foo', 'body': 'bar', 'userId': 1}));

    print(response.statusCode);
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Consumo de serviços avançados")),
        body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(children: [
                  ElevatedButton(onPressed: _post, child: Text("Post")),
                  ElevatedButton(onPressed: _put, child: Text("Salvar")),
                  ElevatedButton(onPressed: () {}, child: Text("Salvar"))
                ]),
                Expanded(
                    child: FutureBuilder<List<Post>>(
                        future: _recuperarPostagens(),
                        builder: (context, snapshot) {
                          String resultado = "teste";
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              print("conexao none");
                              break;
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            case ConnectionState.done:
                              print("conexao done");
                              resultado = "Finalizado";
                              if (snapshot.hasError) {
                                resultado = "Erro ao carregar os dados";
                              } else {
                                return ListView.builder(
                                    itemBuilder: (context, index) {
                                      List<Post> lista =
                                          List.from((snapshot.data as List));
                                      Post post = lista[index];

                                      return ListTile(
                                          title: Text(post.title),
                                          subtitle: Text(post.body));
                                    },
                                    itemCount: snapshot.data?.length);
                              }
                              break;
                            case ConnectionState.active:
                              print("conexao active");
                              break;
                          }

                          return Center(child: Text(resultado));
                        }))
              ],
            )));
  }
}
