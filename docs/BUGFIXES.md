- [x] the design of the page is not like in source.
check https://www.jgive.com/new/he/ils/donation-targets/159183 website again and compare to https://jgivehome.onrender.com/campaigns/orange-garden
the page is divide to nav bar and main . 
inside main part 
1. campaign banner
in the middle of the campaign there is a link to a youtube video 
https://www.youtube.com/watch?v=4Z_xXXR3ddU&t=1s
2. donation menu

Addressed: added a fixed nav bar (`layouts/application.html.erb`), and grouped
the donate button into a bordered "donation menu" card with a tax-credit
note, closer to the reference's bit/donate/tax-info grouping.

Banner video — superseded the initial iframe-embed approach with a reusable
`campaigns/_media_banner` component: a wide background image with a centered
"watch the video" link/button (play icon + label) that opens the campaign's
YouTube video in a new tab. Simpler, avoids iframe-loading/CSP overhead, and
reads more like "a link to a video" than an autoplay-prone embedded player.
`Campaign#video_url` is stored on the model and seeded for הגן הכתום with the
linked video; the component takes `image_url`/`image_alt`/`video_url` so it
can be reused for any campaign banner.