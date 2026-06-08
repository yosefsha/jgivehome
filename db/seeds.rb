# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

orange_garden_story = <<~STORY.strip
  הצטרפו עכשיו והיו ממקימי ׳הגן הכתום׳ — לזכר שירי, אריאל וכפיר ביבס, ולזכר כל ילדי ה-7 באוקטובר.

  אנחנו יוצאים לדרך עם הקמת הגן הכתום — מרחב ראשון מסוגו בישראל שמחבר זיכרון, טבע ילדים וריפוי.
  על פני 20 דונם יוקם מרחב חי של טבע, מים, משחק, משפחה וריפוי - פתוח לכולם. מקום שבו ילדים ירוצו
  וישחקו, משפחות יתכנסו יחד, ואנשים יוכלו לעצור לרגע, לנשום ולהתחבר מחדש. מקום שיכלול גם מרחב
  מכבד לזכר כל ילדי השבעה באוקטובר — כדי לזכור דרך החיים, האור והאהבה.

  הגן הכתום מוקם במגדל העמק, סמוך לגני הילדים "אריאל" ו"כפיר" הנבנים בימים אלה. בגן יוקמו מתחם
  גינון טיפולי-קהילתי, בוסתני פרי ומטעים, נחל אקולוגי, מרחב זיכרון לכל ילדי השבעה באוקטובר,
  אומגה כתומה ומתקני משחק, קיר משאלות, מרחבי פיקניק משפחתיים, אמפיתיאטרון וספרייה חיצונית.

  הפרויקט הוא יוזמה של עמותת ונטעת, בשיתוף משפחת ביבס, עיריית מגדל העמק ומשרד אדריכלי הנוף איזי
  בלנק. עיריית מגדל העמק העניקה את הקרקע והתחייבה לתחזוקה שוטפת — התוכניות מוכנות, ועכשיו זה תלוי
  בנו. כל תרומה תומכת ישירות בהקמת הגן: כל עץ, כל שביל, כל פינה שתוקם — יקרה רק בזכותכם.
STORY

orange_garden = Campaign.find_or_create_by!(slug: "orange-garden") do |campaign|
  campaign.title = "הגן הכתום"
  campaign.story = orange_garden_story
  campaign.cover_image_url = "/images/background_orange.jpg"
  campaign.video_url = "https://www.youtube.com/watch?v=4Z_xXXR3ddU"
  campaign.goal_amount = 5_000_000
end

[
  { amount: 180, label: "נטיעת עץ" },
  { amount: 360, label: "נטיעת 2 עצים", featured: true },
  { amount: 720, label: "נטיעת 3 עצים - לזכרם" },
  { amount: 1_800, label: "בונים מרחב לילדים" },
  { amount: 5_000, label: "בוני הגן הכתום" }
].each do |attrs|
  orange_garden.donation_options.find_or_create_by!(label: attrs[:label]) do |option|
    option.amount = attrs[:amount]
    option.featured = attrs.fetch(:featured, false)
  end
end

library_story = <<~STORY.strip
  ספריית השכונה היא פרויקט קטן ושאפתני: להפוך חדר ריק במרכז הקהילתי לספרייה פתוחה לכל
  המשפחות בשכונה. אנחנו אוספים ספרים, בונים מדפים, ומציעים פינת קריאה נעימה לילדים ולהורים.

  המטרה שלנו היא לגייס מספיק כדי לרכוש ריהוט, מדפים, ומלאי ספרים ראשוני בעברית ובאנגלית,
  ולקיים פעילויות סיפור שבועיות לילדי השכונה. כל תרומה — קטנה כגדולה — מקרבת אותנו ליום
  הפתיחה החגיגי.
STORY

neighborhood_library = Campaign.find_or_create_by!(slug: "neighborhood-library") do |campaign|
  campaign.title = "ספריית השכונה"
  campaign.story = library_story
  campaign.cover_image_url = "/images/background_orange.jpg"
  campaign.goal_amount = 40_000
end

[
  { amount: 50, label: "ספר אחד למדף" },
  { amount: 150, label: "פינת קריאה לילד אחד", featured: true },
  { amount: 500, label: "מדף ספרים שלם" }
].each do |attrs|
  neighborhood_library.donation_options.find_or_create_by!(label: attrs[:label]) do |option|
    option.amount = attrs[:amount]
    option.featured = attrs.fetch(:featured, false)
  end
end

donations = [
  { campaign: orange_garden, amount: 180, frequency: :one_time, status: :paid,
    donor_name: "נועה כהן", donor_email: "noa@example.com", display_preference: :full_name },
  { campaign: orange_garden, amount: 360, frequency: :monthly, status: :paid,
    donor_name: "Yosef Shachnovsky", donor_email: "yosef@example.com", display_preference: :full_name,
    dedication_message: "לזכר שירי, אריאל וכפיר" },
  { campaign: orange_garden, amount: 5_000, frequency: :one_time, status: :pending,
    donor_name: "דניאל לוי", donor_email: "daniel@example.com", display_preference: :first_name },
  { campaign: orange_garden, amount: 720, frequency: :one_time, status: :pending,
    donor_name: "מאיה אברהם", donor_email: "maya@example.com", display_preference: :anonymous,
    dedication_message: "באהבה, לזכרם" },
  { campaign: orange_garden, amount: 1_800, frequency: :monthly, status: :pending,
    donor_name: "אורי שמש", donor_email: "uri@example.com", display_preference: :full_name },
  { campaign: orange_garden, amount: 180, frequency: :one_time, status: :cancelled,
    donor_name: "תמר ברק", donor_email: "tamar@example.com", display_preference: :first_name },
  { campaign: orange_garden, amount: 500_000, frequency: :one_time, status: :paid,
    donor_name: "קרן משפחת רוזנברג", donor_email: "rosenberg-foundation@example.com", display_preference: :full_name,
    dedication_message: "לזכר ילדי ה-7 באוקטובר, באהבה ובכאב" },
  { campaign: orange_garden, amount: 600_000, frequency: :one_time, status: :paid,
    donor_name: "עיריית מגדל העמק", donor_email: "migdal-haemek-municipality@example.com", display_preference: :full_name },
  { campaign: orange_garden, amount: 560_000, frequency: :one_time, status: :pending,
    donor_name: "קרן ידידי הצפון", donor_email: "northern-friends-fund@example.com", display_preference: :full_name,
    dedication_message: "בשם כל התורמים והתורמות שהאמינו בפרויקט" },
  { campaign: neighborhood_library, amount: 150, frequency: :one_time, status: :paid,
    donor_name: "Sarah Cohen", donor_email: "sarah@example.com", display_preference: :full_name,
    dedication_message: "In honor of my grandmother, who taught me to love books" },
  { campaign: neighborhood_library, amount: 50, frequency: :one_time, status: :pending,
    donor_name: "David Mizrahi", donor_email: "david@example.com", display_preference: :first_name },
  { campaign: neighborhood_library, amount: 500, frequency: :monthly, status: :pending,
    donor_name: "Anonymous Donor", donor_email: "anon@example.com", display_preference: :anonymous },
  { campaign: neighborhood_library, amount: 150, frequency: :one_time, status: :paid,
    donor_name: "רינת עזרא", donor_email: "rinat@example.com", display_preference: :full_name }
]

donations.each do |attrs|
  Donation.find_or_create_by!(campaign: attrs[:campaign], donor_email: attrs[:donor_email], amount: attrs[:amount]) do |donation|
    donation.frequency = attrs[:frequency]
    donation.status = attrs[:status]
    donation.donor_name = attrs[:donor_name]
    donation.display_preference = attrs[:display_preference]
    donation.dedication_message = attrs[:dedication_message]
  end
end

puts "Seeded #{Campaign.count} campaigns, #{DonationOption.count} donation options, #{Donation.count} donations."
