// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

// Debug
let debug = true
function dbg(msg){if (debug) console.log(msg)}

// socket
let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()
socket.onClose( e => dbg("Closed connection") )
let channel = socket.channel("room:emo", {})

// Items
let Items = [ "0", "Ruby", "Rails", "Python", "Django", "Flask", "Pyramid", "Elixir", "Phoenix", "Go",
              "PHP", "WordPress", "JavaScript", "JQuery", "React", "RiotJS", "Angular2", "VueJS", "Ember",
              "Gulp", "Brunch", "Grunt", "Webpack", "CSS", "SASS", "PostCSS", "LESS", "Susy", "Neat",
              "Bootstrap 3", "Bootstrap 4", "Foundation 5", "Foundation 6", "Semantic UI", "UIKit",
              "PicnicCSS", "BlazeCSS", "PureCSS", "MinCSS", "Git", "Mercurial", "BitKeeper", "Bazaar",
              "Subversion", "CVS", "Bash", "ZSH", "Linux", "Debian", "Ubuntu", "RedHat", "NixOS", "Alpine", "Slitaz",
              "FreeBSD", "OpenBSD", "Docker", "CoreOS", "Kubernetes", "Mesos", "Deis", "SystemD",
              "Ansible", "Chef", "Salt", "Puppet", "PostgreSQL", "MySQL", "CouchDB", "Riak", "Cassandra", "RethinkDB",
              "GraphQL", "Vim", "Emacs", "Atom", "VSCode", "IntelliJ", "Eclipse", "Geany"]

// Elements
let Item = $("#Item")
let changeItem = $("#changeItem")
let emoMeterInput = $("#emometer-input")
let emoMeterLocal = $("#emometer-local")
let emoValueLocal = $("#emovalue-local")
let emoMeterWorldMax = $("#emometer-world-max")
let emoValueWorldMax = $("#emovalue-world-max")
let emoMeterWorldMin = $("#emometer-world-min")
let emoValueWorldMin = $("#emovalue-world-min")
let emoMeterWorldAvg = $("#emometer-world-avg")
let emoValueWorldAvg = $("#emovalue-world-avg")

let ItemCounter = 1
Item.html(Items[1])

changeItem.on("click", event => {
  dbg('changeItem clicked!')
  if (ItemCounter == Items.length-1) {
    Item.html(Items[1])
    ItemCounter = 1
  } else {
    Item.html(Items[++ItemCounter])
  }
  channel.push("new_itm", { item: ItemCounter })
})

emoMeterInput.on("input", event => {
  channel.push("emo_val", { "emov": parseInt(emoMeterInput.val(),10), "item": ItemCounter })
  dbg('new emoMeterInput value:' + emoMeterInput.val())
})

channel.on("emo_val", data => {
  dbg('new emo data:' + JSON.stringify(data))
  dbg('ItemCounter:' + ItemCounter)
  if (ItemCounter == data.itm) {
    emoValueWorldMax.html (data.max)
    emoMeterWorldMax.val(++data.max)
    emoValueWorldMin.html (data.min)
    emoMeterWorldMin.val(++data.min)
    emoValueWorldAvg.html (data.avg)
    emoMeterWorldAvg.val(++data.avg)
  }
})

channel.on("new_itm", data => {
  dbg('new_itm data:' + JSON.stringify(data))
  emoValueWorldMax.html (data.max)
  emoMeterWorldMax.val(++data.max)
  emoValueWorldMin.html (data.min)
  emoMeterWorldMin.val(++data.min)
  emoValueWorldAvg.html (data.avg)
  emoMeterWorldAvg.val(++data.avg)
  emoMeterInput.val(data.user)
  emoValueLocal.html(data.usr)
  emoMeterLocal.val(++data.usr)
})

channel.join()
  .receive("ok",    resp => { dbg("Joined successfully", resp) })
  .receive("error", resp => { dbg("Unable to join", resp) })

channel.push("new_itm", { item: ItemCounter })

export default socket
