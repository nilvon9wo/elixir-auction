// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

import {Socket} from "phoenix"

const socket = new Socket("/socket", {params: {token: window.userToken}});
socket.connect();

const match = document.location.pathname.match(/\/items\/(\d+)$/);
if (match) {
    const itemId = match[1];
    const channel = socket.channel(`item:${itemId}`, {});

    channel.on("new_bid", data => {
        console.log("new_bid message received", data);
        document.getElementById("bids")
            .insertAdjacentHTML("afterbegin", data.body);
    });

    channel.join()
        .receive("ok", response => {
            console.log("Joined successfully", response)
        })
        .receive("error", response => {
            console.log("Unable to join", response)
        });
}

export default socket
