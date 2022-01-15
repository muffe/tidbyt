load("render.star", "render")
load("http.star", "http")
load("xpath.star", "xpath")
load("time.star", "time")

NOZ_RSS_FEED = "https://www.noz.de/rss/ressort/Osnabr%C3%BCck"

def main():
    news = http.get(
        url=NOZ_RSS_FEED
    )

    xml = xpath.loads(news.body())
    
    title = xml.query("/rss/channel/item/title")
    pubDate = xml.query("/rss/channel/item/pubDate")
    timeObject = time.parse_time(pubDate, "Mon, 2 Jan 2006 15:04:05 -0700")

    pubDate = timeObject.format("15:04")

    return render.Root(
        child = render.Column(
            expanded=True,
            children=[
                render.Box(
                    height=8,
                    child=render.Row(
                        expanded=True, 
                        main_align="space_evenly", 
                        cross_align="center",
                        children = [
                            render.Text(
                               content="noz.de - " + pubDate,
                               color="#00386c",
                            )
                        ],
                    ),
                ),
                render.Box(
                    height=24,
                    child=render.Row(
                        expanded=True, 
                        main_align="space_evenly", 
                        cross_align="center",
                        children = [
                            render.Marquee(
                                height=24,
                                child=render.WrappedText(
                                    content="%s" % title,
                                ),
                                scroll_direction="vertical"
                            )
                        ],
                    ),
                ),
            ],
        )
    )
