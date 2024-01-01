function getFistArticle() {
    var articles = $("article");
    articles.first().css("background-color", "red");
    return articles.length;
}

var isFlutterInAppWebViewReady = false;
window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
    isFlutterInAppWebViewReady = true;
});

function registerBookmarkClickEvent() {
    if (!isFlutterInAppWebViewReady) {
        return;
     }
    //  console.log("需要注册的节点数量:" + $('div[data-testid="bookmark"]:not(.-tmp-click)').length);
     $('div[data-testid="bookmark"]:not(.-tmp-click)').on("click", function () {
             var tweetLink = $(this).parents('article').find('a:has(time)').attr("href");
             var tweetText = $(this).parents('article').find('div[data-testid="tweetText"] span').text();
             var action = $(this).attr('data-testid');
             if(action == 'bookmark') {
                 console.log("add => https://twitter.com" + tweetLink);
                 window.flutter_inappwebview.callHandler('saveTweetLink', tweetText, "https://twitter.com" + tweetLink);
             } else if(action == 'removeBookmark') {
                 console.log("remove => https://twitter.com" + tweetLink);
             }
         }
     ).addClass('-tmp-click');
}
