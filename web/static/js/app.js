// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"


//~ let Items = [ "0", "Phoenix", "Elixir", "Ruby", "Rails", "Python", "Django", "Flask", "Pyramid",
              //~ "PHP", "WordPress", "JavaScript", "JQuery", "React", "RiotJS",
              //~ "Gulp", "Brunch", "Webpack", "CSS", "SASS", "PostCSS", "Foundation",
              //~ "Bootstrap", "Semantic UI", "PicnicCSS", "BlazeCSS", "MinCSS",
              //~ "Linux", "Debian", "Ubuntu", "RedHat", "Alpine", "Slitaz", 
              //~ "Docker", "CoreOS", "Kubernetes", "SystemD", "Ansible", "Chef", "Salt"] 

//~ let Item = $("#Item")
//~ let changeItem = $("#changeItem")

//~ let ItemCounter = 1

//~ changeItem.on("click", event => {
  //~ // channel.push("emo_val", { body: emoInput.val() })
  //~ console.log('changeItem clicked!')
  //~ if (ItemCounter == Items.length) {
    //~ Item.html(Items[1])
    //~ ItemCounter = 1
  //~ } else {
    //~ Item.html(Items[ItemCounter++])
  //~ }
  //~ channel.push("new_item", { item: ItemCounter })
//~ })
