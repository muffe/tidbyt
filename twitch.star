load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")

TWITCH_SUB_API_URL = "https://api.twitch.tv/helix/subscriptions?first=100&broadcaster_id="
TWITCH_USER_API_URL = "https://api.twitch.tv/helix/users?login="
TWITCH_USERNAME = "CHANGE_ME"
TWITCH_API_SECRET = "CHANGE_ME"
TWITCH_API_CLIENT_ID = "CHANGE_ME"

TWITCH_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAAAXNSR0IArs4c6QAAAuxJREFUeF7tnVtu6zAMRKPNdT1dStfTzaXo4+KmKWEPpZFFJ6e/pShljsixLQNuF/Hv7eV6FUMJu1wur++t9QghDwJITl6A5PSaHg2Q6RLnJgBITq/p0VYg+IWflwooNHWAAMSvQLGMVAhAiilQbDlyheAX68hFkBpAALJOgWIzUyEAKaZAseVQIQAppkCx5VAhACmmQLHlLKmQ13f5ULKYXPFy3l58J9kAMSAHiEFEZwqAONU05AKIQURnilMBUQ38epJXvFrwatXTA2mttesiggBx9hZDLoDciLiyMv4tAyCGXe1McSogqoFHAi2yhDQrgKQlmzsAIHP1TWd/WiAVDDyi9bRA1K0bCaT4kXNc2RvDFabuFLYXJEB+35v8KaZeYXvHAUQAsudBzsoCiABkz4MAsqOQ0i7Uqx4lF0AAsle0X/+3nqlzlSVpvhkEkBt5elsdpo6pa6VIy9J02oqiZdGy4v2h9G8ue5MVSMtKChaE07JoWbQsTD1QgEcnPDqRDAYP2fCQ6BE+R7jSvpoXFAG4n41HJ6L+e4dUShqAKCodGAOQY8XefYseIAcCUaYCiKLSpJijxY9+xukve51sAJJ8juQUX31yPPMSlwrZIUqFUCF/tkgZD1HakfMQS5nvM8Z5F67MCZAdlQCyIRAVotTYTczIEa4yFUAUlQCSVGk7/CE9RLl8jWQ52i9K34co20xtWQD5UbOKhwAEIEqBSzGn95AzV8NDeghANgpvhYcABCCSF/QG4SG9yk0aZwUyssbedlfhZm7kd9+PBYhTTUMugBhEdKYAiFNNQy6AGER0pjgVkEcz8Ol36iM7RbnKAsiIwsmxAPkWjJaV3DizwwEyW+Fk/rJAnsEvTmXqAPmPa8nHie9NHSAASXb7OeGhh0RT8UlvPwD5A/cA8YuvGngUF371kQrxQ6JC/JoOZQTIkHz+wUNA8JVxICqA+5nkLwfjKzlIAMnpNT0aINMlzk0wHUhuOUT3KvABWOWLknJ2OW8AAAAASUVORK5CYII=
""")

def main():
    userResponse = http.get(
        url=TWITCH_USER_API_URL + TWITCH_USERNAME, 
        headers={
            'Authorization': 'Bearer ' + TWITCH_API_SECRET,
            'Client-Id': TWITCH_API_CLIENT_ID,
        }
    )

    if userResponse.status_code != 200:
        fail("Twitch request failed with status %d", userResponse.status_code)

    userId = userResponse.json()["data"][0]["id"]

    subData = http.get(
        url=TWITCH_SUB_API_URL + userId, 
        headers={
            'Authorization': 'Bearer ' + TWITCH_API_SECRET,
            'Client-Id': TWITCH_API_CLIENT_ID,
        }
    )

    if subData.status_code != 200:
        fail("Twitch request failed with status %d", subData.status_code)

    users = ""
    total = subData.json()["total"]
    for userData in subData.json()["data"]:
        if userData["user_name"] != TWITCH_USERNAME:
          users = users + "\n" + userData["user_name"]
    
    return render.Root(
        child = render.Column(
            expanded=True,
            children=[
                render.Box(
                    height=24,
                    child=render.Row(
                        expanded=True, 
                        main_align="space_evenly", 
                        cross_align="center",
                        children = [
                            render.Image(
                                src=TWITCH_ICON,
                                width=21,
                                height=21,
                            ),
                            render.Marquee(
                                height=24,
                                child=render.WrappedText("%s" % users),
                                scroll_direction="vertical"
                            )
                        ],
                    ),
                ),
                render.Box(
                   height=8,
                   child=render.Row(
                        expanded=True, 
                        main_align="space_evenly", 
                        cross_align="center",
                        children = [
                            render.Text(
                                "  Subs: %d" % total,
                                height=8,
                            )
                        ],
                    ),
                ),
            ],
        )
    )