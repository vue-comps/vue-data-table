module.exports = {
  module:
    loaders: [
      { test: /\.vue$/, loader: "vue-loader"}
      { test: /\.html$/, loader: "html"}
      { test: /\.css$/, loader: "style-loader!css-loader" }
      { test: /\.json$/, loader: "json-loader" }
    ]
    postLoaders: [
      { test: /vue-icons/, loader: "callback-loader"}
    ]
  resolve:
    extensions: ["",".js",".vue",".coffee"]
  callbackLoader:
    require("vue-icons/icon-loader")(["octicon-info"])
}
