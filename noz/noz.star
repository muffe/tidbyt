load("render.star", "render")
load("http.star", "http")
load("xpath.star", "xpath")
load("time.star", "time")

NOZ_RSS_FEED = "https://www.noz.de/rss"

def main():
    news = http.get(
        url=NOZ_RSS_FEED
    )

    xml = xpath.loads(news.body())
    
    title1 = xml.query("/rss/channel/item[1]/title")
    pubDate1 = xml.query("/rss/channel/item[1]/pubDate")
    timeObject1 = time.parse_time(pubDate1)
    pubDate1 = timeObject1.format("15:04")

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
                               content="noz.de",
                               color="#00386c",
                            ),
                            render.Text(
                               content=pubDate1,
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
                                width=64,
                                height=24,
                                offset_start=24,
                                offset_end=24,
                                child=render.WrappedText(
                                    content="%s" % title1,
                                ),
                                scroll_direction="vertical"
                            )
                        ],
                    ),
                ),
            ],
        )
    )
