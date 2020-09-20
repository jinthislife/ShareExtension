var WebParser = function() {};

WebParser.prototype = {
getDescription: function() {
    var metas = document.getElementsByTagName('meta');
    for (i=0; i<metas.length; i++) {
        if (metas[i].getAttribute("name") == "description") {
            return metas[i].getAttribute("content");
        }
    }
    return "";
},
getImage: function() {
    var metas = document.getElementsByTagName('meta');
    for (i=0; i<metas.length; i++) {
        if (metas[i].getAttribute("name") == "og:image" ||
            metas[i].getAttribute("property") == "og:image" ||
            metas[i].getAttribute("name") == "sailthru.image.full" || metas[i].getAttribute("name") == "twitter:image:src") {
            return metas[i].getAttribute("content");
        }
    }
    return "";
},
run: function(arguments) {
    // Pass the baseURI of the webpage to the extension.
    arguments.completionFunction({"url": document.baseURI, "host": document.location.hostname, "title": document.title, "description": this.getDescription(), "image": this.getImage()});
},
    // Note that the finalize function is only available in iOS.
finalize: function(arguments) {
    // arguments contains the value the extension provides in [NSExtensionContext completeRequestReturningItems:completion:].
    // In this example, the extension provides a color as a returning item.
    // document.body.style.backgroundColor = arguments["bgColor"];
}
};

// The JavaScript file must contain a global object named "ExtensionPreprocessingJS".
var ExtensionPreprocessingJS = new WebParser;

