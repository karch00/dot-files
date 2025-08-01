function login(event) {
    if (event) event.preventDefault();
    lightdm.authenticate("karch");
}
function shutdown() {
    lightdm.shutdown();
}
function restart() {
    lightdm.restart()
}
function suspend() {
    lightdm.suspend()
}


window.authentication_complete = function() {
    if (lightdm.is_authenticated) {
        lightdm.start_session("hyprland");
    }
    else {
        document.getElementById("login-password").value = "";
        document.getElementById("login-password").focus();

        document.getElementById("incorrect-password").style.display = "block";
        document.getElementById("incorrect-password").style.visibility = "visible";
    }
}
window.show_prompt = function(text, type) {
    if (type === "password") {
        const password = document.getElementById("login-password").value;
        lightdm.respond(password);
    }
}
window.show_error = function(text) {};
window.autologin_timer_expired = function() {};


function updateClockAndDate() {
    const now = new Date();
    const time = now.toLocaleTimeString('en-GB', { hour12: false });
    const date = now.toLocaleDateString('en-GB');

    document.getElementById("time").textContent = time;
    document.getElementById("date").textContent = date;
}

window.onload = function() {
    updateClockAndDate();
    setInterval(updateClockAndDate, 1000);

    lightdm.sessions.forEach(session => {
        document.getElementById("debug").textContent = document.getElementById("debug").textContent + `${session.key} - ${session.name}`;
    })
}


