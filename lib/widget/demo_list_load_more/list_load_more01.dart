import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class ListLoadMore01 extends StatefulWidget {
	ListLoadMore01({Key key, this.title}) : super(key: key);
	final String title;

	@override
	_ListLoadMore01State createState() => new _ListLoadMore01State();
}

class _ListLoadMore01State extends State<ListLoadMore01> {

	int page = 1;
	List<String> issues = new List();
	bool loading = false;
	ScrollController _scrollController = new ScrollController();

	Widget _buildLoadText() {
		return Container(
			child: Padding(
				padding: const EdgeInsets.all(18.0),
				child: Center(
					child: Text("加载中..."),
				),
			),
			color: Colors.white70,
		);
	}

//	Widget _buildProgressIndicator() {
//		return new Padding(
//			padding: const EdgeInsets.all(8.0),
//			child: new Center(
//				child: new Opacity(
//					opacity: loading ? 1.0 : 0.0,
//					child: new CircularProgressIndicator(),
//				),
//			),
//		);
//	}

	@override
	void initState() {
		super.initState();

		_refresh();

		_scrollController.addListener(() {
			if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
				print("loadMore");
				_loadMore();
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				title: new Text("加载更多"),
			),
			body: new RefreshIndicator(
				child: new ListView.builder(
					itemCount: issues.length,
					itemBuilder: (BuildContext context, int index) {
						var title = issues[index];
						if (index == issues.length) {
							return _buildLoadText();
						} else {
							return new Container(
								decoration: new BoxDecoration(
									border: new Border(
										bottom: new BorderSide(
											color: Colors.grey.shade300))),
								child: new ListTile(
									key: new ValueKey<String>(title),
									title: new Text("($index) $title")),
							);
						}
					},
					controller: _scrollController,
				),
				onRefresh: _refresh,
			),
		);
	}

	@override
	void dispose() {
		super.dispose();
		_scrollController.dispose();
	}

	Future<void> _refresh() async {
		page = 1;
		if (!loading) {
			setState(() {
				loading = true;
			});

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
					loading = false;
				});
			} finally {}
		}else{
			return _buildLoadText();
		}
	}

	Future<void> _loadMore() async {
		if (!loading) {
			setState(() {
				loading = true;
			});

			try {
				var url = "https://api.github.com/repositories/31792824/issues?page=$page";
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
					loading = false;
				});
			} finally {}
		}
	}
}
