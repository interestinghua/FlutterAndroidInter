import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class ListLoadMore extends StatefulWidget {
	ListLoadMore({Key key, this.title}) : super(key: key);
	final String title;

	@override
	_ListLoadMoreState createState() => new _ListLoadMoreState();
}

class _ListLoadMoreState extends State<ListLoadMore> {

	int page = 1;
	List<String> issues;
	bool isLoading = false;
	Logger log = new Logger(r"ListLoadMore");
	ScrollController _scrollController = new ScrollController();

	Widget _buildProgressTextIndicator() {
		return new Row(
			mainAxisAlignment: MainAxisAlignment.center,
			mainAxisSize: MainAxisSize.max,
			children: [
				new Container(
					child: Padding(
						padding: const EdgeInsets.all(18.0),
						child: Center(
							child: Text("加载中...",
								style: new TextStyle(
									color: Colors.black,
									fontSize: 20.0,
								),
							),
						),
					),
					color: Colors.white70,
				),
				new Container(
					child: Padding(
						padding: const EdgeInsets.all(8.0),
						child: new Center(
							child: new Opacity(
								opacity: isLoading ? 1.0 : 0.0,
								child: new CircularProgressIndicator(),
							),
						),
					),
					color: Colors.white70,
				),
			],
		);
	}

	@override
	void initState() {
		super.initState();

		_scrollController.addListener(() {
			if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
				if (!isLoading) {
					print("_scrollController loadMore");
					_loadMore();
				}
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		var length = issues?.length ?? 0;
		return new Scaffold(
			appBar: new AppBar(
				title: new Text("加载更多"),
			),
			body: new RefreshIndicator(
				displacement: 10.0,
				child: new ListView.builder(
					scrollDirection: Axis.vertical,
//					itemCount: 30,
					itemBuilder: (BuildContext context, int index) {
						print("itemBuilder length = $length, index = $index");

						if (index == length) {
							_loadMore();
							return _buildProgressTextIndicator();
						} else if (index > length) {
							return null;
						}

						var title = issues[index];
						var itemIndex = index + 1;

						return new Container(
							decoration: new BoxDecoration(
								border: new Border(
									bottom: new BorderSide(
										color: Colors.grey.shade300))),
							child: new ListTile(
								key: new ValueKey<String>(title),
								title: new Text("($itemIndex) $title")),
						);
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
		print("========_refresh========");
		page = 1;

		if (isLoading) {
			return null;
		}
		isLoading = true;
		try {
			var url = "https://api.github.com/repositories/31792824/issues?page=$page";
			var resp = await http.get(url);
			var data = json.decode(resp.body);

			print("refresh response data $data");
			print("refresh url $url");

			setState(() {
				if (data is List) {
					if (issues == null) {
						issues = <String>[];
					} else {
						issues.clear();
					}
					data.forEach((dynamic e) {
						if (e is Map) {
							issues.add(e['title'] as String);
						}
					});
				}
			});
		} finally {
			isLoading = false;
		}
	}

	Future<void> _loadMore() async {
		print("========_loadMore========");
		if (isLoading) {
			return null;
		}
		isLoading = true;
		try {
			var url = "https://api.github.com/repositories/31792824/issues?page=$page";
			var resp = await http.get(url);
			var data = json.decode(resp.body);

			print("loadmore response data $data");
			print("loadmore url $url");

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
			isLoading = false;
		}
	}
}
