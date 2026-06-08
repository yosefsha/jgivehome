- [x] the design of the page is not like in source.
check https://www.jgive.com/new/he/ils/donation-targets/159183 website again and compare to https://jgivehome.onrender.com/campaigns/orange-garden
the page is divide to nav bar and main . 
inside main part 
1. campaign banner
in the middle of the campaign there is a link to a youtube video 
https://www.youtube.com/watch?v=4Z_xXXR3ddU&t=1s
2. donation menu

Addressed: added a fixed nav bar (`layouts/application.html.erb`), embedded the
campaign's YouTube video centered over the cover image in the banner
(`Campaign#video_embed_url` derives the `/embed/` URL from a stored
`video_url`, seeded for הגן הכתום with the linked video), and grouped the
donate button into a bordered "donation menu" card with a tax-credit note,
closer to the reference's bit/donate/tax-info grouping.