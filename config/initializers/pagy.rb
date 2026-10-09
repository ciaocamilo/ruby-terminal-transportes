require "pagy/extras/overflow"

Pagy::DEFAULT[:limit] = 15
Pagy::DEFAULT[:overflow] = :last_page
Pagy::I18n.load(locale: "es")
