class SearchResponse {
  final List<String> images;

  SearchResponse({required this.images});

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final List dataList = json['data'] ?? [];

    return SearchResponse(images: dataList.map((e) => e.toString()).toList());
  }
}
