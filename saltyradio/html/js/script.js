lastChannel = 123

$(function() {
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case 'show':
                if (event.data.state) {
                    $('body').fadeIn()
                } else {
                    $('body').fadeOut()
                }
            break
            case 'changeChannel':
                lastChannel = event.data.value

                if (event.data.value == -1) {
                    $(".funk__container h2 span").html("Nicht verbunden");
                } else {
                    $(".funk__container h2 span").html("Verbunden: " + event.data.value);
                }
            break
            case 'addHistory':
                $('.scroll__container').prepend(`
                    <div class="scroll__item" onclick="connect2(${event.data.channel})">
                        <i class="fas fa-wifi"></i>
                        <p><span>ID:</span>${event.data.channel}</p>
                    </div>
                `)
            break
        }
    })

    window.addEventListener('keyup', function(event) {
        switch (event.key) {
            case 'Escape':
                $('body').fadeOut()
                $.post('https://saltyradio/escape', JSON.stringify({}))
            break
        }
    })
})

function disconnect() {
    $.post('https://saltyradio/leaveRadio', JSON.stringify({}))

    $(".funk__container h2 span").html("Nicht verbunden")
}

function connect() {
    var channel = document.getElementById("channel--input").value

    if (channel > 0 || lastChannel != channel) {
        $.post('https://saltyradio/joinRadio', JSON.stringify({
            channel: channel
        }))
    }
}

function connect2(channel) {
    if (channel > 0 || lastChannel != channel) {
        $.post('https://saltyradio/joinRadio', JSON.stringify({
            channel: channel
        }))
    }
}