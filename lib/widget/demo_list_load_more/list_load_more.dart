import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

//void main() => runApp(new MyApp());

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Flutter Demo',
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: new ListLoadMore(title: 'Flutter Demo Home Page'),
//    );
//  }
//}

class ListLoadMore extends StatefulWidget {
	ListLoadMore({Key key, this.title}) : super(key: key);
	final String title;

	@override
	_ListLoadMoreState createState() => new _ListLoadMoreState();
}

class _ListLoadMoreState extends State<ListLoadMore> {
	int page = 1;
	List<String> issues;
	bool loading = false;
	Logger log = new Logger(r"ListLoadMore");

	@override
	Widget build(BuildContext context) {
		var length = issues?.length ?? 0;
		return new Scaffold(
			appBar: new AppBar(
				title: new Text("加载更多"),
			),
			body: new RefreshIndicator(
				child: new ListView.builder(
					itemBuilder: (BuildContext context, int index) {
//            print(" index = $index");

						if (index == length) {
							_load();
//              return new Center(
//                child: new Container(
//                  margin: const EdgeInsets.only(top: 8.0),
//                  width: 32.0,
//                  height: 32.0,
//                  child: const CircularProgressIndicator(),
//                ),
//              );
						} else if (index > length) {
							return null;
						}

						var title = issues[index];
						return new Container(
							decoration: new BoxDecoration(
								border: new Border(
									bottom: new BorderSide(
										color: Colors.grey.shade300))),
							child: new ListTile(
								key: new ValueKey<String>(title),
								title: new Text("($index) $title")),
						);
					},
				),
				onRefresh: _refresh,
			),
		);
	}

	Future<void> _refresh() async {
		page = 1;
		if (loading) {
			return null;
		}
		loading = true;
		try {
			var url =
				"https://api.github.com/repositories/31792824/issues?page=$page";
			var resp = await http.get(url);
			var data = json.decode(resp.body);
			setState(() {
				if (data is List) {
					if (issues == null) {
						issues = <String>[];
					}
					data.forEach((dynamic e) {
						if (e is Map) {
							issues.add(e['title'] as String);
						}
					});
				}
			});
		} finally {
			loading = false;
		}
	}

	Future<void> _load() async {
		if (loading) {
			return null;
		}
		loading = true;
		try {
			var url =
				"https://api.github.com/repositories/31792824/issues?page=$page";
			var resp = await http.get(url);
			var data = json.decode(resp.body);
			setState(() {
				page += 1;
				if (data is List) {
					if (issues == null) {
						issues = <String>[];
					}
					data.forEach((dynamic e) {
						if (e is Map) {
							issues.add(e['title'] as String);
						}
					});
				}
			});
		} finally {
			loading = false;
		}
	}
}
