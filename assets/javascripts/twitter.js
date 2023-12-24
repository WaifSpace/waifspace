function getFistArticle() {
    var articles = $("article");
    articles.first().css( "background-color", "red" );
    return articles.length;
}