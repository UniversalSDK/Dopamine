/**
 * Dopamine — Client-Side Application Script
 * Features:
 *  - 11-Language Client-Side i18n Engine (Auto-detect & LocalStorage persist)
 *  - Interactive macOS Sequoia Menu Bar Simulation & State Machine
 *  - 1-Click Homebrew Copy with Toast Notification
 *  - Google Analytics 4 (GA4) Custom Event Tracking
 *  - Interactive FAQ Accordion
 *  - 3D Parallax Tilt for Hero Icon
 */

// ==========================================================================
// 1. i18n TRANSLATIONS DICTIONARY (11 LANGUAGES)
// ==========================================================================
const i18nData = {
  en: {
    lang_name: "English",
    nav_comparison: "Comparison",
    nav_interactive: "Interactive Demo",
    nav_features: "Features",
    nav_specs: "Tech Specs",
    nav_faq: "FAQ",
    nav_download: "Get App",
    hero_badge: "macOS Sequoia Ready • 100% Native Apple Silicon",
    hero_title_p1: "Keep your Mac awake.",
    hero_title_p2: "Protect your Liquid Retina screen.",
    hero_subtitle: "The ultimate dual-engine macOS utility. Execute long-running renders, builds, and downloads with the lid closed — while cutting internal display power to absolute 0.0 nits to eliminate heat traps and screen burn.",
    btn_dmg_title: "Download DMG (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey to Sequoia • 2.6 MB",
    btn_pkg_title: "Download PKG Installer",
    btn_pkg_sub: "Enterprise / IT Admin Deployment",
    brew_label: "Install via Homebrew:",
    btn_copy: "Copy",
    btn_copied: "Copied!",
    meta_backlight: "0.0 Nits Backlight Cutoff",
    meta_native: "Native Swift 6 • 0% CPU",
    trust_hardened: "Apple Hardened Runtime",
    trust_battery: "Intelligent Battery Safeguard",
    trust_privacy: "Zero Telemetry Without Consent",
    comp_tag: "Hardware Reality Check",
    comp_title: "Why Old Keep-Awake Tools Damage Your Mac",
    comp_subtitle: "Traditional tools like Amphetamine, Caffeine, and KeepingYouAwake were built for older Intel laptops. On modern MacBook Pro Liquid Retina XDR displays, they create dangerous thermal traps.",
    comp_old_badge: "Legacy Utilities (Amphetamine, Caffeine)",
    comp_old_lid_label: "Lid Closed: Display Trapped ON",
    comp_old_stat_backlight: "Trapped Mini-LED Backlight",
    comp_old_head: "Thermal & Coating Degradation",
    comp_old_p1_title: "Heat Trapped Against Keyboard:",
    comp_old_p1_desc: "Liquid Retina XDR mini-LEDs pump thermal energy straight into the closed keys, accelerating anti-reflective coating wear.",
    comp_old_p2_title: "Wasted Battery & Cycle Count:",
    comp_old_p2_desc: "Powering millions of display subpixels for an invisible closed screen drains 15–30% more battery every hour.",
    comp_old_p3_title: "Forced Clamshell Cables:",
    comp_old_p3_desc: "Apple default clamshell requires an external power brick and external display just to prevent sleep.",
    comp_ag_badge: "Dopamine Dual-Engine Solution",
    comp_ag_lid_label: "Lid Closed: Hardware 0.0 nits",
    comp_ag_stat_backlight: "True Hardware Blackout",
    comp_ag_head: "Cold Silicon, Continuous Compute",
    comp_ag_p1_title: "Zero-Nit CoreDisplay Cutoff:",
    comp_ag_p1_desc: "Direct IOKit / CoreGraphics hardware register call turns off the mini-LED backlight instantly when the lid closes.",
    comp_ag_p2_title: "Zero Heat Dissipation to Keys:",
    comp_ag_p2_desc: "Your Liquid Retina screen stays stone-cold while CPU/GPU render at maximum performance inside your backpack or desk.",
    comp_ag_p3_title: "True Cable-Free Clamshell:",
    comp_ag_p3_desc: "No external monitor or power adapter required. Safely compiles Swift, renders Blender, or trains models on battery.",
    demo_tag: "Live Interactive Simulation",
    demo_title: "Experience the macOS Menu Bar App",
    demo_subtitle: "Click the Dopamine menu icon below to toggle active sleep prevention, change icons, and explore the native macOS Sequoia menu.",
    menu_awake_active: "Dopamine: Session Active",
    menu_awake_inactive: "Dopamine: Inactive",
    menu_clamshell_safe: "Display Backlight: 0.0 nits on Lid Close",
    menu_clamshell_off: "Standard macOS Sleep Policy",
    menu_duration_title: "Session Duration",
    menu_indefinite: "Indefinitely (Until Disengaged)",
    menu_15m: "For 15 Minutes",
    menu_1h: "For 1 Hour",
    menu_2h: "For 2 Hours",
    menu_cut_backlight: "Turn Off Backlight on Lid Close",
    menu_allow_display_sleep: "Allow Screen Sleep While Keeping CPU Awake",
    menu_battery_guard: "Battery Safeguard: Stop below 10%",
    menu_preferences: "Preferences...",
    menu_disable: "Disengage Dopamine",
    menu_enable: "Engage Dopamine",
    demo_toggle_hint: "Click menu bar item to toggle state or click button:",
    demo_btn_turn_off: "Toggle Inactive State",
    demo_btn_turn_on: "Toggle Active State",
    demo_icon_style: "Select Menu Bar Icon Style:",
    feat_tag: "Architected For Apple Silicon",
    feat_title: "Designed For Professional Mac Workflows",
    feat_subtitle: "Every feature in Dopamine is engineered with Swift 6 and low-level IOKit APIs to deliver unmatched performance without compromising hardware longevity.",
    feat1_title: "True 0.0 Nits Hardware Blackout",
    feat1_desc: "Does not just display a black screensaver. It disengages the physical Mini-LED and OLED backlight controller via IOKit DisplayServices, ensuring zero light bleed and zero keyboard heating.",
    feat2_title: "Cable-Free Clamshell Mode",
    feat2_desc: "Apple forces you to connect both power and an external monitor to use Clamshell mode. Dopamine eliminates this constraint safely, allowing fully portable closed-lid operation anywhere.",
    feat3_title: "Automated Battery Safeguard",
    feat3_desc: "Set a critical threshold (e.g., 10% or 20%). If battery level drops below your limit or you disconnect MagSafe, Dopamine gracefully relinquishes assertions to prevent accidental deep discharge.",
    feat4_title: "0.0% Idle CPU & 14MB RAM",
    feat4_desc: "Written 100% in pure native Swift with AppKit status bar architecture. No Electron, no web views, and no background pollers draining your M-series energy cores.",
    feat5_title: "Decoupled Display & CPU Sleep",
    feat5_desc: "Keep CPU compute, audio playback, and network sockets alive while letting your screen go to sleep normally on your desk. Best of both worlds for battery life and workflow continuity.",
    feat6_title: "Privacy-First & Zero Telemetry",
    feat6_desc: "No analytics or tracking without explicit user consent. Complies fully with Apple Hardened Runtime. All preferences are stored strictly in your local macOS domain defaults.",
    specs_tag: "Native Engineering",
    specs_title: "Technical Specifications",
    specs_subtitle: "Pure Swift 6 architecture built specifically for the unified memory architecture of Apple Silicon.",
    spec_k_os: "macOS Compatibility",
    spec_k_arch: "Hardware Architecture",
    spec_k_lang: "Language & Framework",
    spec_k_footprint: "Binary Size & Footprint",
    spec_k_security: "Security & Runtime",
    spec_k_i18n: "Available Languages",
    spec_k_distribution: "Distribution Formats",
    faq_tag: "Got Questions?",
    faq_title: "Frequently Asked Questions",
    faq_subtitle: "Everything you need to know about display safety, power assertions, and installation.",
    faq_q1: "How does Dopamine turn off the display while keeping the Mac awake?",
    faq_a1: "Dopamine uses macOS IOKit power assertion APIs (PreventUserIdleSystemSleep) to keep the kernel and background processes running, while registering a low-level DisplayServices hardware notification. When clamshell closure is detected, Dopamine immediately signals the display controller to cut power to the backlight LEDs, achieving genuine 0.0 nits true black without putting the SoC to sleep.",
    faq_q2: "Why is Dopamine safer for Liquid Retina screens than Amphetamine or Caffeine?",
    faq_a2: "Liquid Retina XDR screens contain thousands of high-intensity mini-LEDs. When legacy tools keep the Mac awake with the lid closed, those mini-LEDs remain continuously energized at high nits inside a sealed, unventilated air gap right against your keyboard keys. Trapped heat can damage delicate anti-reflective coatings and LCD layers. Dopamine physically cuts backlight power to 0 nits, keeping the screen cool.",
    faq_q3: "Will Dopamine drain my battery if I accidentally leave it on?",
    faq_a3: "No. Dopamine includes an automatic Battery Guard monitor. You can configure it to auto-disengage whenever your battery level drops to 10% (or any threshold you choose), or whenever MagSafe is disconnected. This guarantees you will never open your bag to a drained battery.",
    faq_q4: "Do I need an external monitor or power adapter to use clamshell mode?",
    faq_a4: "No! Apple's default macOS clamshell mode strictly demands both an external power adapter and an external display. Dopamine enables standalone clamshell mode: you can close your MacBook on battery power with no cables connected and it will keep your background tasks running seamlessly.",
    faq_q5: "How do I install Dopamine via Homebrew?",
    faq_a5: "Simply open your Terminal and paste: brew tap UniversalSDK/dopamine && brew install --cask dopamine. Homebrew will automatically verify the SHA-256 checksum and link Dopamine into your /Applications directory.",
    cta_title: "Protect your Mac. Unleash your workflow.",
    cta_desc: "Download Dopamine today. Zero telemetry, zero bloatware, 100% native Apple Silicon performance.",
    cta_btn_dmg: "Download Dopamine DMG",
    footer_tagline: "Next-generation power & display controller for macOS.",
    footer_downloads: "Downloads",
    footer_legal: "Legal & Privacy",
    back_to_top: "Back to top",
    toast_copied: "Command copied to clipboard!"
  },

  uk: {
    lang_name: "Українська",
    nav_comparison: "Порівняння",
    nav_interactive: "Інтерактивне демо",
    nav_features: "Можливості",
    nav_specs: "Специфікації",
    nav_faq: "Часті питання",
    nav_download: "Завантажити",
    hero_badge: "Готово до macOS Sequoia • 100% Native Apple Silicon",
    hero_title_p1: "Тримайте Mac активним.",
    hero_title_p2: "Захистіть екран Liquid Retina.",
    hero_subtitle: "Досконала двоядерна утиліта для macOS. Запускайте тривалий рендеринг, білди та завантаження із закритою кришкою — з апаратним вимкненням підсвічування до абсолютних 0.0 ніт для захисту від перегріву екрана.",
    btn_dmg_title: "Завантажити DMG (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey до Sequoia • 2.6 МБ",
    btn_pkg_title: "Завантажити інсталятор PKG",
    btn_pkg_sub: "Для корпоративного та системного розгортання",
    brew_label: "Встановлення через Homebrew:",
    btn_copy: "Скопіювати",
    btn_copied: "Скопійовано!",
    meta_backlight: "Апаратні 0.0 ніт при закритті",
    meta_native: "Нативний Swift 6 • 0% CPU",
    trust_hardened: "Apple Hardened Runtime",
    trust_battery: "Розумний захист батареї",
    trust_privacy: "Нуль телеметрії без згоди",
    comp_tag: "Апаратна реальність",
    comp_title: "Чому старі утиліти шкодять вашому Mac",
    comp_subtitle: "Традиційні інструменти (Amphetamine, Caffeine) створювалися для старих ноутбуків Intel. На сучасних дисплеях Liquid Retina XDR вони утворюють небезпечну термічну пастку.",
    comp_old_badge: "Застарілі утиліти (Amphetamine, Caffeine)",
    comp_old_lid_label: "Кришка закрита: Екран світиться під клавіатурою",
    comp_old_stat_backlight: "Затиснуте Mini-LED підсвічування",
    comp_old_head: "Термічна деградація та пошкодження покриття",
    comp_old_p1_title: "Тепло затиснуте біля клавіш:",
    comp_old_p1_desc: "Міні-діоди Liquid Retina XDR випромінюють тепло прямо в закриті клавіші, руйнуючи покриття антивідблиску.",
    comp_old_p2_title: "Марна витрата заряду батареї:",
    comp_old_p2_desc: "Живлення мільйонів субпікселів на невидимому закритому екрані витрачає на 15–30% більше енергії щогодини.",
    comp_old_p3_title: "Примусові дроти для Clamshell:",
    comp_old_p3_desc: "Стандартний режим Apple вимагає підключення зовнішнього монітора та зарядки навіть для простих завдань.",
    comp_ag_badge: "Дводвигунне рішення Dopamine",
    comp_ag_lid_label: "Кришка закрита: Апаратні 0.0 ніт",
    comp_ag_stat_backlight: "Справжнє апаратне знеструмлення",
    comp_ag_head: "Холодний процесор, безперервна робота",
    comp_ag_p1_title: "Апаратне відключення CoreDisplay:",
    comp_ag_p1_desc: "Прямий виклик регістрів IOKit вимикає фізичні світлодіоди дисплея в момент закриття кришки.",
    comp_ag_p2_title: "Нуль теплового навантаження на матрицю:",
    comp_ag_p2_desc: "Дисплей Liquid Retina залишається крижаним, поки чіп Apple Silicon рендерить чи компілює на повній швидкості.",
    comp_ag_p3_title: "Справжній Clamshell без проводів:",
    comp_ag_p3_desc: "Жодного монітора чи кабелю живлення. Працюйте в дорозі чи в рюкзаку безпечно для пристрою.",
    demo_tag: "Жива інтерактивна симуляція",
    demo_title: "Спробуйте меню програми прямо зараз",
    demo_subtitle: "Натисніть на значок Dopamine у рядку меню нижче, щоб увімкнути активний режим, змінити іконку та переглянути нативне меню.",
    menu_awake_active: "Dopamine: Сесія активна",
    menu_awake_inactive: "Dopamine: Неактивний",
    menu_clamshell_safe: "Підсвічування: 0.0 ніт при закритті",
    menu_clamshell_off: "Стандартна політика сну macOS",
    menu_duration_title: "Тривалість сесії",
    menu_indefinite: "Безстроково (до вимкнення)",
    menu_15m: "На 15 хвилин",
    menu_1h: "На 1 годину",
    menu_2h: "На 2 години",
    menu_cut_backlight: "Вимкнути підсвічування при закритті",
    menu_allow_display_sleep: "Дозволити сон екрана при активному процесорі",
    menu_battery_guard: "Захист батареї: зупинити нижче 10%",
    menu_preferences: "Налаштування...",
    menu_disable: "Деактивувати Dopamine",
    menu_enable: "Активувати Dopamine",
    demo_toggle_hint: "Натисніть на іконку в меню або скористайтесь кнопкою:",
    demo_btn_turn_off: "Перемкнути в неактивний стан",
    demo_btn_turn_on: "Активувати Dopamine",
    demo_icon_style: "Виберіть стиль іконки в рядку меню:",
    feat_tag: "Створено для Apple Silicon",
    feat_title: "Інструмент для професійних робочих процесів",
    feat_subtitle: "Кожна функція розроблена мовою Swift 6 з прямим використанням низькорівневих API IOKit без компромісів щодо безпеки заліза.",
    feat1_title: "Справжнє знеструмлення 0.0 ніт",
    feat1_desc: "Це не просто чорна заставка. Це фізичне вимкнення підсвічування Mini-LED/OLED через IOKit DisplayServices без світлових плям.",
    feat2_title: "Бездротовий Clamshell режим",
    feat2_desc: "Dopamine звільняє вас від обмежень Apple, дозволяючи закривати кришку при роботі від батареї без зовнішніх дисплеїв.",
    feat3_title: "Автоматичний захист акумулятора",
    feat3_desc: "Вкажіть поріг заряду (наприклад, 10%). При його досягненні блокування сну автоматично зніметься, рятуючи Mac від розрядки.",
    feat4_title: "0.0% CPU та всього 14 МБ пам'яті",
    feat4_desc: "100% чистий нативний Swift та AppKit. Жодного Electron, веб-рушіїв або фонових циклів опитування.",
    feat5_title: "Роздільний сон екрана та системи",
    feat5_desc: "Екран може засинати для економії заряду на столі, поки процесор, завантаження та мережа продовжують працювати без пауз.",
    feat6_title: "Повна приватність і безпека",
    feat6_desc: "Жодного збору даних без вашої згоди. Повна відповідність вимогам Hardened Runtime. Всі налаштування зберігаються суто локально.",
    specs_tag: "Нативна інженерія",
    specs_title: "Технічні характеристики",
    specs_subtitle: "Архітектура Swift 6, оптимізована під об'єднану пам'ять чіпів Apple Silicon.",
    spec_k_os: "Сумісність з macOS",
    spec_k_arch: "Архітектура",
    spec_k_lang: "Мова та фреймворки",
    spec_k_footprint: "Розмір та навантаження",
    spec_k_security: "Безпека та середовище",
    spec_k_i18n: "Підтримувані мови",
    spec_k_distribution: "Формати дистрибуції",
    faq_tag: "Маєте питання?",
    faq_title: "Поширені запитання",
    faq_subtitle: "Все про безпеку дисплея, керування живленням та встановлення утиліти.",
    faq_q1: "Як Dopamine вимикає дисплей, зберігаючи активність системи?",
    faq_a1: "Dopamine створює блокування PreventUserIdleSystemSleep в ядрі IOKit, одночасно перехоплюючи стан датчика кришки MacBook. При закритті викликається низькорівнева команда DisplayServices, яка знеструмлює світлодіоди підсвічування.",
    faq_q2: "Чому Dopamine безпечніший для Liquid Retina за інші аналоги?",
    faq_a2: "Екрани Liquid Retina XDR мають тисячі надяскравих міні-світлодіодів. Якщо кришка закрита, а підсвічування горить, тепло не розсіюється, пошкоджуючи клавіатуру та покриття антивідблиску. Dopamine гасить світло на 100%.",
    faq_q3: "Чи може Dopamine розрядити акумулятор у рюкзаку?",
    faq_a3: "Ні. Вбудований модуль контролю батареї автоматично вимикає збереження активності при падінні заряду нижче встановленого рівня (наприклад, 10%).",
    faq_q4: "Чи потрібен зовнішній монітор для закритої кришки?",
    faq_a4: "Ні! На відміну від стандартного обмеження Apple, Dopamine дозволяє закривати ноутбук без підключених кабелів та моніторів.",
    faq_q5: "Як встановити Dopamine через Homebrew?",
    faq_a5: "Відкрийте Термінал і виконайте: brew tap UniversalSDK/dopamine && brew install --cask dopamine. Homebrew автоматично перевірить контрольні суми SHA-256.",
    cta_title: "Захистіть свій Mac. Прискорте продуктивність.",
    cta_desc: "Завантажте Dopamine сьогодні. Жодного зайвого коду, максимальна швидкість Apple Silicon.",
    cta_btn_dmg: "Завантажити Dopamine DMG",
    footer_tagline: "Контролер живлення та дисплея нового покоління для macOS.",
    footer_downloads: "Завантаження",
    footer_legal: "Правова інформація",
    back_to_top: "Вгору",
    toast_copied: "Команду скопійовано в буфер обміну!"
  },

  de: {
    lang_name: "Deutsch",
    nav_comparison: "Vergleich",
    nav_interactive: "Interaktive Demo",
    nav_features: "Funktionen",
    nav_specs: "Spezifikationen",
    nav_faq: "FAQ",
    nav_download: "Herunterladen",
    hero_badge: "macOS Sequoia bereit • 100% Native Apple Silicon",
    hero_title_p1: "Halten Sie Ihren Mac wach.",
    hero_title_p2: "Schützen Sie Ihr Liquid Retina Display.",
    hero_subtitle: "Das fortschrittlichste macOS-Dienstprogramm. Führen Sie Renderings, Builds und Downloads bei geschlossenem Deckel aus – mit echter 0,0-Nits-Hintergrundbeleuchtungsabschaltung gegen Hitzestau.",
    btn_dmg_title: "DMG herunterladen (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey bis Sequoia • 2.6 MB",
    btn_pkg_title: "PKG-Installer herunterladen",
    btn_pkg_sub: "Enterprise- & IT-Bereitstellung",
    brew_label: "Installation via Homebrew:",
    btn_copy: "Kopieren",
    btn_copied: "Kopiert!",
    meta_backlight: "0,0 Nits Hardware-Abschaltung",
    meta_native: "Natives Swift 6 • 0% CPU",
    trust_hardened: "Apple Hardened Runtime",
    trust_battery: "Intelligenter Batterieschutz",
    trust_privacy: "Keine Telemetrie ohne Zustimmung",
    comp_tag: "Hardware-Faktencheck",
    comp_title: "Warum alte Keep-Awake-Tools Ihrem Mac schaden",
    comp_subtitle: "Klassische Tools wie Amphetamine wurden für Intel-Laptops gebaut. Auf Liquid Retina XDR Displays erzeugen sie gefährliche Hitzestaus.",
    comp_old_badge: "Klassische Tools (Amphetamine, Caffeine)",
    comp_old_lid_label: "Deckel zu: Display bleibt eingeschaltet",
    comp_old_stat_backlight: "Gefangene Mini-LED-Beleuchtung",
    comp_old_head: "Thermische Belastung & Beschichtungsabrieb",
    comp_old_p1_title: "Hitze gegen Tastatur gestaut:",
    comp_old_p1_desc: "Mini-LEDs strahlen Wärme direkt auf die geschlossenen Tasten ab und beschädigen die Antireflexbeschichtung.",
    comp_old_p2_title: "Verschwendete Batterieenergie:",
    comp_old_p2_desc: "Millionen Subpixel für einen geschlossenen Bildschirm verbrauchen 15–30% mehr Akku pro Stunde.",
    comp_old_p3_title: "Erzwungene Clamshell-Kabel:",
    comp_old_p3_desc: "Apples Standard verlangt externes Netzteil und Monitor, um den Ruhezustand zu verhindern.",
    comp_ag_badge: "Dopamine Dual-Engine Lösung",
    comp_ag_lid_label: "Deckel zu: Echte 0,0 Nits",
    comp_ag_stat_backlight: "Echte Hardware-Abschaltung",
    comp_ag_head: "Kühles Silizium, ununterbrochene Leistung",
    comp_ag_p1_title: "0,0-Nits CoreDisplay-Abschaltung:",
    comp_ag_p1_desc: "Direkter IOKit-Befehl trennt die Stromzufuhr zu den Mini-LEDs sofort beim Zuklappen.",
    comp_ag_p2_title: "Keine Hitzeübertragung auf die Tasten:",
    comp_ag_p2_desc: "Ihr Bildschirm bleibt eiskalt, während M-Chips auf Höchstleistung rendern.",
    comp_ag_p3_title: "Kabelloser Clamshell-Modus:",
    comp_ag_p3_desc: "Kein externer Monitor oder Netzteil erforderlich. Sicherer Betrieb im Akkumodus.",
    demo_tag: "Interaktive Menüleisten-Simulation",
    demo_title: "Testen Sie die Menüleiste live",
    demo_subtitle: "Klicken Sie auf das Menüleistensymbol, um den Wach-Modus zu aktivieren oder Icons zu wechseln.",
    menu_awake_active: "Dopamine: Aktiv",
    menu_awake_inactive: "Dopamine: Inaktiv",
    menu_clamshell_safe: "Display-Beleuchtung: 0,0 Nits bei geschlossenem Deckel",
    menu_clamshell_off: "Standard-macOS-Ruhezustand",
    menu_duration_title: "Sitzungsdauer",
    menu_indefinite: "Unbegrenzt",
    menu_15m: "Für 15 Minuten",
    menu_1h: "Für 1 Stunde",
    menu_2h: "Für 2 Stunden",
    menu_cut_backlight: "Beleuchtung bei geschlossenem Deckel abschalten",
    menu_allow_display_sleep: "Bildschirmruhezustand erlauben, CPU wachhalten",
    menu_battery_guard: "Batterieschutz: Stopp unter 10%",
    menu_preferences: "Einstellungen...",
    menu_disable: "Dopamine deaktivieren",
    menu_enable: "Dopamine aktivieren",
    demo_toggle_hint: "Klicken Sie auf das Menüleisten-Symbol oder den Button:",
    demo_btn_turn_off: "Inaktiv schalten",
    demo_btn_turn_on: "Aktivieren",
    demo_icon_style: "Menüleisten-Symbol wählen:",
    feat_tag: "Für Apple Silicon optimiert",
    feat_title: "Entwickelt für Profi-Workflows",
    feat_subtitle: "Präzise mit Swift 6 und IOKit-Schnittstellen für maximale Effizienz gebaut.",
    feat1_title: "Echte 0,0 Nits Hardware-Dunkelheit",
    feat1_desc: "Kein schwarzer Bildschirmschoner, sondern echte Stromabschaltung des Displays über IOKit.",
    feat2_title: "Kabelloser Clamshell-Modus",
    feat2_desc: "Schließen Sie Ihr MacBook sicher unterwegs ohne Ladegerät und externen Bildschirm.",
    feat3_title: "Automatischer Batterieschutz",
    feat3_desc: "Beendet den Wach-Modus bei kritischem Akkustand, um Tiefentladung zu verhindern.",
    feat4_title: "0,0% Idle-CPU & 14 MB RAM",
    feat4_desc: "100% natives Swift und AppKit. Kein ressourcenhungriges Electron.",
    feat5_title: "Entkoppelter Display- & System-Schlaf",
    feat5_desc: "Display schläft energiesparend, während Hintergrundprozesse weiterlaufen.",
    feat6_title: "Datenschutz & Zero Telemetrie",
    feat6_desc: "Keine Datenweitergabe ohne Zustimmung. Apple Hardened Runtime zertifiziert.",
    specs_tag: "Technische Daten",
    specs_title: "Technische Spezifikationen",
    specs_subtitle: "Swift 6 Architektur, optimiert für Apple Silicon Unified Memory.",
    spec_k_os: "macOS-Kompatibilität",
    spec_k_arch: "Hardware-Architektur",
    spec_k_lang: "Sprache & Frameworks",
    spec_k_footprint: "Dateigröße & Speicher",
    spec_k_security: "Sicherheitsstandard",
    spec_k_i18n: "Sprachen",
    spec_k_distribution: "Formate",
    faq_tag: "Fragen & Antworten",
    faq_title: "Häufig gestellte Fragen",
    faq_subtitle: "Alles über Displayschutz, Energieverwaltung und Installation.",
    faq_q1: "Wie schaltet Dopamine das Display ab, während der Mac wach bleibt?",
    faq_a1: "Dopamine nutzt IOKit-Power-Assertions für den Kernel und schaltet über DisplayServices die Hintergrundbeleuchtung beim Schließen hardwareseitig ab.",
    faq_q2: "Warum schützt Dopamine mein Liquid Retina Display?",
    faq_a2: "Weil Mini-LEDs bei geschlossenem Deckel enorme Hitze gegen die Tastatur strahlen. Dopamine schaltet die LEDs komplett stromlos.",
    faq_q3: "Entlädt Dopamine meinen Akku?",
    faq_a3: "Nein, der integrierte Batterieschutz beendet das Wachhalten rechtzeitig bei niedrigem Akkustand.",
    faq_q4: "Brauche ich einen externen Monitor?",
    faq_a4: "Nein, Dopamine funktioniert völlig autonom ohne externe Peripherie.",
    faq_q5: "Wie installiere ich Dopamine mit Homebrew?",
    faq_a5: "Führen Sie im Terminal aus: brew tap UniversalSDK/dopamine && brew install --cask dopamine.",
    cta_title: "Schützen Sie Ihren Mac. Maximieren Sie Ihre Produktivität.",
    cta_desc: "Laden Sie Dopamine herunter. 100% native Performance für Apple Silicon.",
    cta_btn_dmg: "Dopamine DMG herunterladen",
    footer_tagline: "Die nächste Generation von Display- & Energiesteuerung für macOS.",
    footer_downloads: "Downloads",
    footer_legal: "Rechtliches",
    back_to_top: "Nach oben",
    toast_copied: "Befehl in die Zwischenablage kopiert!"
  },

  fr: {
    lang_name: "Français",
    nav_comparison: "Comparatif",
    nav_interactive: "Démo Interactive",
    nav_features: "Fonctionnalités",
    nav_specs: "Spécifications",
    nav_faq: "FAQ",
    nav_download: "Télécharger",
    hero_badge: "Prêt pour macOS Sequoia • 100% Apple Silicon Natif",
    hero_title_p1: "Gardez votre Mac éveillé.",
    hero_title_p2: "Protégez votre écran Liquid Retina.",
    hero_subtitle: "L'utilitaire macOS nouvelle génération. Effectuez vos rendus, compilations et téléchargements avec le capot fermé, grâce à l'extinction matérielle à 0,0 nits contre la surchauffe.",
    btn_dmg_title: "Télécharger DMG (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey à Sequoia • 2.6 Mo",
    btn_pkg_title: "Télécharger le package PKG",
    btn_pkg_sub: "Déploiement Entreprise & Admin IT",
    brew_label: "Installation via Homebrew :",
    btn_copy: "Copier",
    btn_copied: "Copié !",
    meta_backlight: "Coupure matérielle 0.0 Nits",
    meta_native: "Swift 6 Natif • 0% CPU",
    trust_hardened: "Apple Hardened Runtime",
    trust_battery: "Protection Intelligente Batterie",
    trust_privacy: "Zéro Télémétrie Sans Accord",
    comp_tag: "Réalité Matérielle",
    comp_title: "Pourquoi les anciens utilitaires abîment votre Mac",
    comp_subtitle: "Les outils comme Amphetamine ont été conçus pour les processeurs Intel. Sur les écrans Liquid Retina XDR, ils créent un piège thermique dangereux.",
    comp_old_badge: "Anciens outils (Amphetamine, Caffeine)",
    comp_old_lid_label: "Capot fermé : écran sous tension",
    comp_old_stat_backlight: "Rétroéclairage Mini-LED piégé",
    comp_old_head: "Dégradation thermique & revêtement abîmé",
    comp_old_p1_title: "Chaleur piégée contre les touches :",
    comp_old_p1_desc: "Les mini-LEDs projettent leur chaleur sur le clavier, accélérant l'usure du traitement antireflet.",
    comp_old_p2_title: "Batterie gaspillée inutilement :",
    comp_old_p2_desc: "Alimenter des millions de sous-pixels invisibles consomme 15 à 30% de batterie en plus par heure.",
    comp_old_p3_title: "Câbles Clamshell obligatoires :",
    comp_old_p3_desc: "Le mode standard Apple exige un chargeur et un écran externe branchés.",
    comp_ag_badge: "Solution Dual-Engine Dopamine",
    comp_ag_lid_label: "Capot fermé : 0.0 nits réels",
    comp_ag_stat_backlight: "Extinction Matérielle Totale",
    comp_ag_head: "Puce au frais, calculs continus",
    comp_ag_p1_title: "Coupure CoreDisplay 0.0 Nits :",
    comp_ag_p1_desc: "Appel direct aux registres IOKit coupant le rétroéclairage dès la fermeture du capot.",
    comp_ag_p2_title: "Aucune chaleur transmise au clavier :",
    comp_ag_p2_desc: "Votre dalle Liquid Retina reste froide pendant que le Mac calcule à pleine vitesse.",
    comp_ag_p3_title: "Vrai Clamshell sans aucun fil :",
    comp_ag_p3_desc: "Aucun câble requis. Fonctionne en toute sécurité sur batterie.",
    demo_tag: "Simulation Interactive en Direct",
    demo_title: "Découvrez l'icône de la barre des menus",
    demo_subtitle: "Cliquez sur l'élément de menu Dopamine ci-dessous pour tester l'activation et changer les icônes.",
    menu_awake_active: "Dopamine : Session Active",
    menu_awake_inactive: "Dopamine : Inactif",
    menu_clamshell_safe: "Rétroéclairage : 0.0 nits capot fermé",
    menu_clamshell_off: "Veille standard macOS",
    menu_duration_title: "Durée de la session",
    menu_indefinite: "Indéfiniment",
    menu_15m: "Pendant 15 minutes",
    menu_1h: "Pendant 1 heure",
    menu_2h: "Pendant 2 heures",
    menu_cut_backlight: "Couper l'écran à la fermeture",
    menu_allow_display_sleep: "Autoriser veille écran avec CPU actif",
    menu_battery_guard: "Protection batterie : arrêt sous 10%",
    menu_preferences: "Préférences...",
    menu_disable: "Désactiver Dopamine",
    menu_enable: "Activer Dopamine",
    demo_toggle_hint: "Cliquez sur l'icône ou sur le bouton :",
    demo_btn_turn_off: "Passer en inactif",
    demo_btn_turn_on: "Activer Dopamine",
    demo_icon_style: "Style d'icône dans la barre de menus :",
    feat_tag: "Conçu pour Apple Silicon",
    feat_title: "Pour les flux de travail professionnels",
    feat_subtitle: "Développé en Swift 6 avec les API IOKit bas niveau pour des performances optimales.",
    feat1_title: "Véritable noir absolu 0.0 nits",
    feat1_desc: "Pas un économiseur d'écran noir, mais une coupure matérielle de l'alimentation des LED.",
    feat2_title: "Mode Clamshell sans fil",
    feat2_desc: "Fermez votre MacBook en déplacement sans être branché au secteur.",
    feat3_title: "Protection automatique de batterie",
    feat3_desc: "Désactive la veille prolongée si le niveau de batterie passe sous votre seuil critique.",
    feat4_title: "0.0% CPU & seulement 14 Mo de RAM",
    feat4_desc: "100% Swift et AppKit natifs, sans surcharge Electron.",
    feat5_title: "Veille découplée écran et système",
    feat5_desc: "Laissez l'écran s'éteindre sur votre bureau pendant que le processeur travaille.",
    feat6_title: "Confidentialité totale",
    feat6_desc: "Aucune télémétrie sans accord explicite. Conforme Hardened Runtime.",
    specs_tag: "Ingénierie Native",
    specs_title: "Spécifications Techniques",
    specs_subtitle: "Architecture Swift 6 conçue pour la mémoire unifiée Apple Silicon.",
    spec_k_os: "Compatibilité macOS",
    spec_k_arch: "Architecture Matérielle",
    spec_k_lang: "Langage & Frameworks",
    spec_k_footprint: "Poids & Empreinte RAM",
    spec_k_security: "Sécurité & Signature",
    spec_k_i18n: "Langues disponibles",
    spec_k_distribution: "Formats de distribution",
    faq_tag: "Questions Fréquentes",
    faq_title: "Foire Aux Questions",
    faq_subtitle: "Tout comprendre sur la protection de l'écran et les assertions d'alimentation.",
    faq_q1: "Comment Dopamine éteint l'écran tout en gardant le Mac éveillé ?",
    faq_a1: "Grâce aux assertions IOKit (PreventUserIdleSystemSleep) combinées au signal matériel DisplayServices coupant l'alimentation des LEDs.",
    faq_q2: "Pourquoi est-ce plus sûr pour mon écran Liquid Retina ?",
    faq_a2: "Parce que les milliers de mini-LEDs confinées contre les touches fermées génèrent une chaleur nocive. Dopamine les éteint totalement.",
    faq_q3: "Vais-je vider ma batterie par inadvertance ?",
    faq_a3: "Non, la coupure automatique au seuil choisi (ex. 10%) évite toute décharge complète.",
    faq_q4: "Faut-il un écran ou un chargeur branché ?",
    faq_a4: "Non, Dopamine déverrouille le mode capot fermé autonome sur batterie.",
    faq_q5: "Comment installer avec Homebrew ?",
    faq_a5: "Entrez simplement dans le Terminal : brew tap UniversalSDK/dopamine && brew install --cask dopamine.",
    cta_title: "Protégez votre Mac. Libérez votre productivité.",
    cta_desc: "Téléchargez Dopamine dès aujourd'hui. Performance 100% native.",
    cta_btn_dmg: "Télécharger Dopamine DMG",
    footer_tagline: "Contrôleur d'alimentation et d'affichage nouvelle génération pour macOS.",
    footer_downloads: "Téléchargements",
    footer_legal: "Légal",
    back_to_top: "Haut de page",
    toast_copied: "Commande copiée dans le presse-papier !"
  },

  ja: {
    lang_name: "日本語",
    nav_comparison: "比較",
    nav_interactive: "インタラクティブ体験",
    nav_features: "機能",
    nav_specs: "仕様",
    nav_faq: "よくある質問",
    nav_download: "ダウンロード",
    hero_badge: "macOS Sequoia 対応 • 100% Apple Silicon ネイティブ",
    hero_title_p1: "Macのスリープを防ぐ。",
    hero_title_p2: "Liquid Retinaディスプレイを守る。",
    hero_subtitle: "次世代のmacOSスリープ制御ユーティリティ。クラムシェル（画面を閉じた状態）でも、バックライトを物理的に0.0ニトまで完全に消灯。発熱によるキーボードと液晶コーティングの熱損傷を防ぎます。",
    btn_dmg_title: "DMGをダウンロード (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey〜Sequoia • 2.6 MB",
    btn_pkg_title: "PKGインストーラーをダウンロード",
    btn_pkg_sub: "エンタープライズ / IT管理者向け",
    brew_label: "Homebrewでインストール:",
    btn_copy: "コピー",
    btn_copied: "コピー完了!",
    meta_backlight: "閉じた状態で0.0ニト完全消灯",
    meta_native: "Swift 6 ネイティブ • CPU 0%",
    trust_hardened: "Apple Hardened Runtime 対応",
    trust_battery: "スマートバッテリー保護機能",
    trust_privacy: "同意なきテレメトリゼロ",
    comp_tag: "ハードウェアの真実",
    comp_title: "従来のツールがMacを傷める理由",
    comp_subtitle: "Amphetamineなどの旧世代ツールはIntel時代に作られました。現代のLiquid Retina XDR画面では、閉じた内部に高温の熱がこもります。",
    comp_old_badge: "従来のツール (Amphetamine, Caffeine)",
    comp_old_lid_label: "閉じた状態：画面が点灯したまま",
    comp_old_stat_backlight: "Mini-LEDの熱がこもる",
    comp_old_head: "熱劣化と画面コーティングの剥離",
    comp_old_p1_title: "キーボードに伝わる高熱：",
    comp_old_p1_desc: "高輝度Mini-LEDの熱が閉じたキーボードに直接伝わり、反射防止コーティングを劣化させます。",
    comp_old_p2_title: "無駄なバッテリー消費：",
    comp_old_p2_desc: "見えない画面の何百万ものサブピクセルを点灯させ続けることで電力を浪費します。",
    comp_old_p3_title: "外部ディスプレイと電源の強制：",
    comp_old_p3_desc: "Apple公式のクラムシェルモードは外部モニターと電源アダプターが必須です。",
    comp_ag_badge: "Dopamine デュアルエンジン",
    comp_ag_lid_label: "閉じた状態：ハードウェア 0.0 ニト",
    comp_ag_stat_backlight: "真のハードウェア消灯",
    comp_ag_head: "熱を持たず、計算処理を継続",
    comp_ag_p1_title: "CoreDisplay 0.0ニト完全カット：",
    comp_ag_p1_desc: "IOKitの直接制御により、蓋が閉じた瞬間にバックライト電源を物理的に切断します。",
    comp_ag_p2_title: "キーボードへの放熱ゼロ：",
    comp_ag_p2_desc: "画面は冷たいまま、Mシリーズチップが最高速度でレンダリングやビルドを続行します。",
    comp_ag_p3_title: "ケーブル不要のクラムシェル：",
    comp_ag_p3_desc: "電源アダプターやモニターなしで、外出先やバッグ内でも安全に動作します。",
    demo_tag: "ライブインタラクティブシミュレーション",
    demo_title: "メニューバーの動作を体感",
    demo_subtitle: "下のメニューバーアイコンをクリックして、起動状態の切り替えやアイコン変更をお試しください。",
    menu_awake_active: "Dopamine: セッション実行中",
    menu_awake_inactive: "Dopamine: 待機中",
    menu_clamshell_safe: "バックライト：蓋を閉じると0.0ニト",
    menu_clamshell_off: "通常のmacOSスリープ設定",
    menu_duration_title: "継続時間",
    menu_indefinite: "無期限（手動停止まで）",
    menu_15m: "15分間",
    menu_1h: "1時間",
    menu_2h: "2時間",
    menu_cut_backlight: "蓋を閉じた時にバックライトを消灯",
    menu_allow_display_sleep: "画面スリープを許可しCPUを維持",
    menu_battery_guard: "バッテリー保護: 10%未満で自動停止",
    menu_preferences: "設定...",
    menu_disable: "Dopamineを停止",
    menu_enable: "Dopamineを開始",
    demo_toggle_hint: "メニューバーアイコンまたは下のボタンをクリック：",
    demo_btn_turn_off: "停止状態に切り替え",
    demo_btn_turn_on: "有効化する",
    demo_icon_style: "アイコンスタイルの選択:",
    feat_tag: "Apple Silicon専用設計",
    feat_title: "プロの開発・制作ワークフローへ",
    feat_subtitle: "Swift 6と低レベルIOKit APIを駆使し、ハードウェア寿命を犠牲にしない設計。",
    feat1_title: "物理的 0.0 ニト完全消灯",
    feat1_desc: "単なる黒い画面ではなく、IOKitを通じてMini-LEDバックライトへの通電を直接遮断します。",
    feat2_title: "完全スタンドアロン・クラムシェル",
    feat2_desc: "外部ディスプレイや充電器の制約を解除し、バッテリー駆動のまま蓋を閉じて使用可能。",
    feat3_title: "インテリジェント・バッテリー保護",
    feat3_desc: "指定残量（例：10%）を下回ると自動で解除され、不意の完全放電を防ぎます。",
    feat4_title: "アイドル時CPU 0.0% & メモリ14MB",
    feat4_desc: "純粋なネイティブSwift製。Electronのような無駄なリソース消費は皆無です。",
    feat5_title: "画面とCPUの個別スリープ制御",
    feat5_desc: "デスク上では画面を省電力で休ませつつ、バックグラウンド処理は止めません。",
    feat6_title: "プライバシー最優先・テレメトリなし",
    feat6_desc: "ユーザーの明示的な同意なくデータを送信しません。設定はローカルに保存されます。",
    specs_tag: "ネイティブ仕様",
    specs_title: "技術仕様",
    specs_subtitle: "Apple Siliconのユニファイドメモリに最適化されたSwift 6設計。",
    spec_k_os: "対応OS",
    spec_k_arch: "対応アーキテクチャ",
    spec_k_lang: "開発言語・フレームワーク",
    spec_k_footprint: "サイズ・メモリ消費",
    spec_k_security: "セキュリティ",
    spec_k_i18n: "対応言語",
    spec_k_distribution: "配布形式",
    faq_tag: "よくあるご質問",
    faq_title: "FAQ",
    faq_subtitle: "画面保護やスリープ制御の仕組みについてお答えします。",
    faq_q1: "画面を消灯したままMacを動かし続ける仕組みは？",
    faq_a1: "IOKitのPreventUserIdleSystemSleepアサーションでシステムを稼働させつつ、蓋の開閉検知時にDisplayServicesでバックライト電源を切断します。",
    faq_q2: "なぜLiquid Retina画面に安全なのですか？",
    faq_a2: "Liquid Retina XDRの密閉空間での発熱を防ぐためです。バックライトを完全に切断することで熱の蓄積を防ぎます。",
    faq_q3: "バッテリーを使い切ってしまう心配は？",
    faq_a3: "ありません。バッテリー監視機能が指定残量（例：10%）で自動的にセッションを終了します。",
    faq_q4: "外部モニターは必要ですか？",
    faq_a4: "一切不要です。MacBook単体で閉じたまま動作させることができます。",
    faq_q5: "Homebrewでのインストール手順は？",
    faq_a5: "ターミナルで brew tap UniversalSDK/dopamine && brew install --cask dopamine と入力するだけです。",
    cta_title: "Macを守り、最高のパフォーマンスを。",
    cta_desc: "今すぐDopamineをダウンロード。完全なApple Siliconネイティブ体験を。",
    cta_btn_dmg: "Dopamine DMGをダウンロード",
    footer_tagline: "macOS向け次世代電源・ディスプレイ制御ユーティリティ。",
    footer_downloads: "ダウンロード",
    footer_legal: "法約",
    back_to_top: "トップへ戻る",
    toast_copied: "コマンドをクリップボードにコピーしました！"
  },

  es: {
    lang_name: "Español",
    nav_comparison: "Comparativa",
    nav_interactive: "Demo Interactiva",
    nav_features: "Funciones",
    nav_specs: "Especificaciones",
    nav_faq: "Preguntas",
    nav_download: "Descargar",
    hero_badge: "Listo para macOS Sequoia • 100% Apple Silicon Nativo",
    hero_title_p1: "Mantén tu Mac activo.",
    hero_title_p2: "Protege tu pantalla Liquid Retina.",
    hero_subtitle: "La utilidad definitiva para macOS. Ejecuta renders y descargas con la tapa cerrada: apagado de hardware a 0.0 nits para eliminar trampas de calor y cuidar tu pantalla.",
    btn_dmg_title: "Descargar DMG (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey a Sequoia • 2.6 MB",
    btn_pkg_title: "Descargar instalador PKG",
    btn_pkg_sub: "Despliegue empresarial y administradores TI",
    brew_label: "Instalar con Homebrew:",
    btn_copy: "Copiar",
    btn_copied: "¡Copiado!",
    meta_backlight: "Apagado real a 0.0 Nits",
    meta_native: "Swift 6 Nativo • 0% CPU",
    trust_hardened: "Apple Hardened Runtime",
    trust_battery: "Protector Inteligente de Batería",
    trust_privacy: "Sin telemetría sin consentimiento",
    comp_tag: "Realidad del Hardware",
    comp_title: "Por qué las apps antiguas dañan tu Mac",
    comp_subtitle: "Herramientas como Amphetamine se crearon para Intel. En pantallas Liquid Retina XDR generan un sobrecalentamiento peligroso al cerrar la tapa.",
    comp_old_badge: "Utilidades clásicas (Amphetamine, Caffeine)",
    comp_old_lid_label: "Tapa cerrada: Pantalla encendida",
    comp_old_stat_backlight: "Mini-LED atrapado encendido",
    comp_old_head: "Degradación térmica de pantalla y teclado",
    comp_old_p1_title: "Calor atrapado contra el teclado:",
    comp_old_p1_desc: "Los mini-LEDs bombean calor directo a las teclas, desgastando el recubrimiento antirreflejos.",
    comp_old_p2_title: "Batería desperdiciada:",
    comp_old_p2_desc: "Alimentar millones de subpíxeles invisibles gasta un 15–30% más de batería por hora.",
    comp_old_p3_title: "Cables obligatorios:",
    comp_old_p3_desc: "Apple exige pantalla externa y cargador conectado para no suspenderse.",
    comp_ag_badge: "Solución Dopamine Dual-Engine",
    comp_ag_lid_label: "Tapa cerrada: 0.0 nits reales",
    comp_ag_stat_backlight: "Apagado total por hardware",
    comp_ag_head: "Silicio fresco, cálculo ininterrumpido",
    comp_ag_p1_title: "Corte CoreDisplay a 0.0 Nits:",
    comp_ag_p1_desc: "Comando directo a IOKit que desenergiza las luces LED al cerrar la tapa.",
    comp_ag_p2_title: "Cero calor transmitido:",
    comp_ag_p2_desc: "Tu pantalla se mantiene fría mientras la CPU y GPU renderizan al máximo.",
    comp_ag_p3_title: "Modo Clamshell sin cables:",
    comp_ag_p3_desc: "No necesitas monitores ni cargadores. Funciona con total seguridad con batería.",
    demo_tag: "Simulación Interactiva",
    demo_title: "Prueba la app en la barra de menús",
    demo_subtitle: "Haz clic en el icono de Dopamine para activar o desactivar la sesión y cambiar de icono.",
    menu_awake_active: "Dopamine: Sesión Activa",
    menu_awake_inactive: "Dopamine: Inactivo",
    menu_clamshell_safe: "Retroiluminación: 0.0 nits con tapa cerrada",
    menu_clamshell_off: "Suspensión estándar de macOS",
    menu_duration_title: "Duración de la sesión",
    menu_indefinite: "Indefinidamente",
    menu_15m: "Durante 15 minutos",
    menu_1h: "Durante 1 hora",
    menu_2h: "Durante 2 horas",
    menu_cut_backlight: "Apagar pantalla al cerrar la tapa",
    menu_allow_display_sleep: "Permitir reposo de pantalla con CPU activa",
    menu_battery_guard: "Protector de batería: parar bajo 10%",
    menu_preferences: "Preferencias...",
    menu_disable: "Desactivar Dopamine",
    menu_enable: "Activar Dopamine",
    demo_toggle_hint: "Haz clic en la barra o usa el botón:",
    demo_btn_turn_off: "Poner en inactivo",
    demo_btn_turn_on: "Activar Dopamine",
    demo_icon_style: "Seleccionar estilo de icono:",
    feat_tag: "Diseñado para Apple Silicon",
    feat_title: "Para flujos de trabajo profesionales",
    feat_subtitle: "Ingeniería Swift 6 con llamadas IOKit de bajo nivel para proteger tu hardware.",
    feat1_title: "0.0 Nits auténticos por hardware",
    feat1_desc: "No es un salvapantallas negro; es el apagado físico de los LEDs mediante IOKit.",
    feat2_title: "Modo Clamshell autónomo",
    feat2_desc: "Cierra tu MacBook sin depender de cables ni pantallas externas.",
    feat3_title: "Salvaguarda inteligente de batería",
    feat3_desc: "Finaliza la sesión al bajar de un porcentaje crítico para evitar descargas totales.",
    feat4_title: "0.0% CPU en reposo y 14 MB RAM",
    feat4_desc: "Puro Swift nativo. Sin el consumo excesivo de Electron.",
    feat5_title: "Reposo desacoplado de pantalla y CPU",
    feat5_desc: "Deja que la pantalla descanse en tu escritorio mientras tus tareas continúan.",
    feat6_title: "Privacidad y cero telemetría",
    feat6_desc: "Sin rastreo sin tu consentimiento. Compatible con Apple Hardened Runtime.",
    specs_tag: "Ingeniería Nativa",
    specs_title: "Especificaciones Técnicas",
    specs_subtitle: "Arquitectura nativa optimizada para memoria unificada de Apple Silicon.",
    spec_k_os: "Compatibilidad macOS",
    spec_k_arch: "Arquitectura",
    spec_k_lang: "Lenguaje y Frameworks",
    spec_k_footprint: "Tamaño y Memoria",
    spec_k_security: "Seguridad y Notarización",
    spec_k_i18n: "Idiomas",
    spec_k_distribution: "Formatos",
    faq_tag: "Preguntas Frecuentes",
    faq_title: "Preguntas y Respuestas",
    faq_subtitle: "Todo sobre la protección de tu pantalla y la gestión de energía.",
    faq_q1: "¿Cómo apaga la pantalla manteniendo el Mac activo?",
    faq_a1: "Usa PreventUserIdleSystemSleep en IOKit y envía una señal directa por DisplayServices al cerrar la tapa para desenergizar los LEDs.",
    faq_q2: "¿Por qué protege mi pantalla Liquid Retina?",
    faq_a2: "Porque evita que miles de mini-LEDs calienten el teclado cerrado, protegiendo las capas ópticas.",
    faq_q3: "¿Agotará mi batería por descuido?",
    faq_a3: "No, su monitor de batería detiene la sesión antes de que se agote la carga.",
    faq_q4: "¿Necesito una pantalla externa?",
    faq_a4: "No, Dopamine permite cerrar la tapa usando solo la batería interna.",
    faq_q5: "¿Cómo lo instalo con Homebrew?",
    faq_a5: "Ejecuta en tu Terminal: brew tap UniversalSDK/dopamine && brew install --cask dopamine.",
    cta_title: "Protege tu Mac. Maximiza tu productividad.",
    cta_desc: "Descarga Dopamine hoy mismo. 100% nativo para Apple Silicon.",
    cta_btn_dmg: "Descargar Dopamine DMG",
    footer_tagline: "Control de pantalla y energía de última generación para macOS.",
    footer_downloads: "Descargas",
    footer_legal: "Legal",
    back_to_top: "Volver arriba",
    toast_copied: "¡Comando copiado al portapapeles!"
  },

  zh: {
    lang_name: "简体中文",
    nav_comparison: "对比分析",
    nav_interactive: "交互体验",
    nav_features: "核心功能",
    nav_specs: "技术规格",
    nav_faq: "常见问题",
    nav_download: "下载软件",
    hero_badge: "适配 macOS Sequoia • 100% 原生 Apple Silicon",
    hero_title_p1: "保持 Mac 持续运行。",
    hero_title_p2: "保护 Liquid Retina 视网膜屏幕。",
    hero_subtitle: "新一代 macOS 防休眠与屏幕保护神器。支持合盖状态下持续渲染、编译与下载，同时硬件级将内屏背光切断至真正的 0.0 尼特，杜绝热量积聚与屏幕涂层损坏。",
    btn_dmg_title: "下载 DMG (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey 至 Sequoia • 2.6 MB",
    btn_pkg_title: "下载 PKG 安装包",
    btn_pkg_sub: "企业与 IT 批量部署专用",
    brew_label: "通过 Homebrew 安装:",
    btn_copy: "复制",
    btn_copied: "已复制!",
    meta_backlight: "合盖 0.0 尼特物理切断",
    meta_native: "原生 Swift 6 • 0% CPU 占用",
    trust_hardened: "Apple Hardened Runtime 认证",
    trust_battery: "智能电池放电保护",
    trust_privacy: "未经允许绝无遥测收集",
    comp_tag: "硬件真实真相",
    comp_title: "为什么传统防休眠工具会损伤屏幕",
    comp_subtitle: "Amphetamine 等旧工具是为早期 Intel 笔记本设计的。在当今的 Liquid Retina XDR 屏幕上，合盖亮屏会造成极其严重的热量陷阱。",
    comp_old_badge: "传统工具 (Amphetamine, Caffeine)",
    comp_old_lid_label: "合盖状态：屏幕依然通电发热",
    comp_old_stat_backlight: "被困住的 Mini-LED 高热背光",
    comp_old_head: "高温导致涂层脱落与硬件老化",
    comp_old_p1_title: "热量直冲键盘：",
    comp_old_p1_desc: "XDR 屏幕的数千颗微型 LED 将热量直接泵入闭合的键盘缝隙，加速抗反射涂层老化磨损。",
    comp_old_p2_title: "电量浪费严重：",
    comp_old_p2_desc: "为看不见的闭合屏幕维持数百万像素供电，每小时额外多耗费 15–30% 电池电量。",
    comp_old_p3_title: "强制连接电源与外接屏：",
    comp_old_p3_desc: "苹果原生合盖模式必须插入电源适配器和外接显示器，无法外出便携使用。",
    comp_ag_badge: "Dopamine 双引擎解决方案",
    comp_ag_lid_label: "合盖状态：硬件级 0.0 尼特",
    comp_ag_stat_backlight: "物理级纯黑断电",
    comp_ag_head: "芯片冷酷运行，算力从不停歇",
    comp_ag_p1_title: "CoreDisplay 0.0 尼特物理断电：",
    comp_ag_p1_desc: "合盖瞬间直接调用底层 IOKit 寄存器断开背光供电，屏幕彻底冷寂不发光。",
    comp_ag_p2_title: "键盘与屏幕零热量接触：",
    comp_ag_p2_desc: "即使放在背包或桌上全力跑渲染或编译，内屏表面温度依旧冰凉。",
    comp_ag_p3_title: "真·无外接线缆合盖模式：",
    comp_ag_p3_desc: "无需任何外接显示器或电源插头，依靠纯电池便能安全持续工作。",
    demo_tag: "实时交互模拟",
    demo_title: "体验 macOS 状态栏应用",
    demo_subtitle: "点击下方模拟菜单栏中的 Dopamine 图标，感受原生切换体验与精美菜单。",
    menu_awake_active: "Dopamine: 会话运行中",
    menu_awake_inactive: "Dopamine: 已停止",
    menu_clamshell_safe: "背光控制：合盖时 0.0 尼特",
    menu_clamshell_off: "macOS 标准睡眠策略",
    menu_duration_title: "持续时间",
    menu_indefinite: "无限期（直到手动停止）",
    menu_15m: "15 分钟",
    menu_1h: "1 小时",
    menu_2h: "2 小时",
    menu_cut_backlight: "合盖时切断屏幕背光",
    menu_allow_display_sleep: "允许屏幕休眠但保持 CPU 运转",
    menu_battery_guard: "低电量保护：低于 10% 自动停止",
    menu_preferences: "偏好设置...",
    menu_disable: "停止 Dopamine",
    menu_enable: "启用 Dopamine",
    demo_toggle_hint: "点击状态栏图标或右侧按钮切换：",
    demo_btn_turn_off: "切换为停止状态",
    demo_btn_turn_on: "切换为激活状态",
    demo_icon_style: "选择状态栏图标样式:",
    feat_tag: "为 Apple Silicon 专属打造",
    feat_title: "专为专业工作流设计",
    feat_subtitle: "全栈采用 Swift 6 与底层 IOKit 框架开发，无任何冗余开销。",
    feat1_title: "真正的 0.0 尼特硬件黑屏",
    feat1_desc: "不是显示黑色屏保，而是通过 IOKit DisplayServices 直接断开 Mini-LED 电源。",
    feat2_title: "真免线缆合盖运行",
    feat2_desc: "彻底摆脱苹果必须接外接显示器和充电器的限制，随时随地合盖运行任务。",
    feat3_title: "智能电池电量安全防护",
    feat3_desc: "可自定义阈值（如 10%），电量过低时自动释放休眠锁定，防止电池过放损害寿命。",
    feat4_title: "0.0% 空闲 CPU 与 14MB 内存",
    feat4_desc: "100% 原生 Swift 与 AppKit 架构，没有昂贵庞大的 Electron 资源损耗。",
    feat5_title: "屏幕与系统休眠独立解耦",
    feat5_desc: "放桌上使用时允许内屏息屏省电，而后台进程与网络连接全速运行。",
    feat6_title: "隐私第一，拒绝任何流氓遥测",
    feat6_desc: "未经用户同意绝不上传任何分析数据。所有设置完全存储在本地。",
    specs_tag: "原生工程指标",
    specs_title: "技术规格参数",
    specs_subtitle: "基于 Swift 6 构建，专为 Apple Silicon 统一内存架构调优。",
    spec_k_os: "支持系统",
    spec_k_arch: "硬件架构",
    spec_k_lang: "开发语言与框架",
    spec_k_footprint: "安装体积与内存",
    spec_k_security: "安全性与签名",
    spec_k_i18n: "支持语言",
    spec_k_distribution: "分发格式",
    faq_tag: "解答疑问",
    faq_title: "常见问题解答",
    faq_subtitle: "关于屏幕安全、电源断言以及安装的全面解析。",
    faq_q1: "Dopamine 如何做到在保持 Mac 唤醒的同时切断屏幕背光？",
    faq_a1: "它通过 IOKit 的 PreventUserIdleSystemSleep API 维持系统运算，同时监听合盖事件并通过底层 DisplayServices 接口切断背光灯珠供电。",
    faq_q2: "为什么它比 Amphetamine 对 Liquid Retina 屏幕更安全？",
    faq_a2: "因为闭合状态下，高热的 Mini-LED 会把热量直接烘烤在屏幕涂层上。物理断电能彻底解决散热积聚问题。",
    faq_q3: "放在包里会导致电池完全耗尽吗？",
    faq_a3: "不会。电池守护模块会在电量降至设定值（如 10%）时自动恢复系统休眠保护。",
    faq_q4: "使用合盖模式需要外接显示器吗？",
    faq_a4: "完全不需要。Dopamine 解除了苹果原生的外接屏限制。",
    faq_q5: "如何通过 Homebrew 安装？",
    faq_a5: "只需在终端中运行：brew tap UniversalSDK/dopamine && brew install --cask dopamine 即可。",
    cta_title: "守护您的 Mac 屏幕，释放极限生产力。",
    cta_desc: "立即下载 Dopamine。轻巧、强大、纯净的原生 macOS 体验。",
    cta_btn_dmg: "下载 Dopamine DMG",
    footer_tagline: "适用于 macOS 的新一代电源与显示控制工具。",
    footer_downloads: "软件下载",
    footer_legal: "法律与隐私",
    back_to_top: "回到顶部",
    toast_copied: "安装命令已复制到剪贴板！"
  },

  it: {
    lang_name: "Italiano",
    nav_comparison: "Confronto",
    nav_interactive: "Demo Interattiva",
    nav_features: "Funzionalità",
    nav_specs: "Specifiche",
    nav_faq: "FAQ",
    nav_download: "Scarica",
    hero_badge: "Pronto per macOS Sequoia • 100% Nativo Apple Silicon",
    hero_title_p1: "Mantieni il tuo Mac sveglio.",
    hero_title_p2: "Proteggi il display Liquid Retina.",
    hero_subtitle: "La nuova generazione di utility per macOS. Esegui render, build e download a coperchio chiuso, con spegnimento hardware della retroilluminazione a 0.0 nits per evitare surriscaldamenti.",
    btn_dmg_title: "Scarica DMG (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey a Sequoia • 2.6 MB",
    btn_pkg_title: "Scarica programma d'installazione PKG",
    btn_pkg_sub: "Per distribuzioni aziendali e IT",
    brew_label: "Installa tramite Homebrew:",
    btn_copy: "Copia",
    btn_copied: "Copiato!",
    meta_backlight: "Taglio hardware a 0.0 Nits",
    meta_native: "Swift 6 Nativo • 0% CPU",
    trust_hardened: "Apple Hardened Runtime",
    trust_battery: "Protezione Batteria Intelligente",
    trust_privacy: "Zero telemetria senza consenso",
    comp_tag: "Realtà dell'Hardware",
    comp_title: "Perché le vecchie utility danneggiano il tuo Mac",
    comp_subtitle: "Strumenti come Amphetamine sono nati per processori Intel. Sugli schermi Liquid Retina XDR creano pericolose trappole di calore a coperchio chiuso.",
    comp_old_badge: "Vecchi strumenti (Amphetamine, Caffeine)",
    comp_old_lid_label: "Coperchio chiuso: display acceso",
    comp_old_stat_backlight: "Retroilluminazione Mini-LED intrappolata",
    comp_old_head: "Degrado termico e del rivestimento",
    comp_old_p1_title: "Calore diretto sui tasti:",
    comp_old_p1_desc: "I mini-LED convogliano calore sui tasti, rovinando il rivestimento antiriflesso.",
    comp_old_p2_title: "Batteria sprecata:",
    comp_old_p2_desc: "Alimentare milioni di subpixel invisibili consuma il 15–30% in più di batteria ogni ora.",
    comp_old_p3_title: "Cavi obbligatori:",
    comp_old_p3_desc: "La modalità standard Apple richiede alimentatore e monitor esterno.",
    comp_ag_badge: "Soluzione Dopamine Dual-Engine",
    comp_ag_lid_label: "Coperchio chiuso: 0.0 nits reali",
    comp_ag_stat_backlight: "Spegnimento Hardware Reale",
    comp_ag_head: "Silicio fresco, calcolo continuo",
    comp_ag_p1_title: "Spegnimento CoreDisplay a 0.0 Nits:",
    comp_ag_p1_desc: "Comando IOKit a basso livello che toglie corrente ai LED non appena si chiude il coperchio.",
    comp_ag_p2_title: "Zero calore sui tasti:",
    comp_ag_p2_desc: "Il display resta freddo mentre la CPU/GPU lavora al massimo regime.",
    comp_ag_p3_title: "Vero Clamshell senza cavi:",
    comp_ag_p3_desc: "Nessun monitor o cavo necessario. Funziona in mobilità su batteria.",
    demo_tag: "Simulazione Interattiva dal Vivo",
    demo_title: "Prova la barra dei menu macOS",
    demo_subtitle: "Fai clic sull'icona di Dopamine qui sotto per attivare la sessione ed esplorare il menu.",
    menu_awake_active: "Dopamine: Sessione Attiva",
    menu_awake_inactive: "Dopamine: Inattivo",
    menu_clamshell_safe: "Retroilluminazione: 0.0 nits a coperchio chiuso",
    menu_clamshell_off: "Sospensione standard macOS",
    menu_duration_title: "Durata della sessione",
    menu_indefinite: "A tempo indeterminato",
    menu_15m: "Per 15 minuti",
    menu_1h: "Per 1 ora",
    menu_2h: "Per 2 ore",
    menu_cut_backlight: "Spegni retroilluminazione alla chiusura",
    menu_allow_display_sleep: "Consenti sospensione schermo con CPU attiva",
    menu_battery_guard: "Protezione batteria: stop sotto il 10%",
    menu_preferences: "Preferenze...",
    menu_disable: "Disattiva Dopamine",
    menu_enable: "Attiva Dopamine",
    demo_toggle_hint: "Fai clic sull'icona o usa il pulsante:",
    demo_btn_turn_off: "Imposta su inattivo",
    demo_btn_turn_on: "Attiva Dopamine",
    demo_icon_style: "Stile icona nella barra dei menu:",
    feat_tag: "Progettato per Apple Silicon",
    feat_title: "Creato per flussi di lavoro professionali",
    feat_subtitle: "Sviluppato in Swift 6 e API IOKit a basso livello per la massima efficienza hardware.",
    feat1_title: "Zero nits autentici via hardware",
    feat1_desc: "Non un semplice screensaver nero: toglie alimentazione ai LED fisici via IOKit.",
    feat2_title: "Modalità Clamshell wireless",
    feat2_desc: "Chiudi il coperchio in viaggio senza dipendere da caricatori o schermi esterni.",
    feat3_title: "Protezione automatica batteria",
    feat3_desc: "Interrompe la veglia quando il livello scende sotto la soglia scelta per evitare scariche profonde.",
    feat4_title: "0.0% CPU e soli 14 MB di RAM",
    feat4_desc: "100% nativo Swift e AppKit. Nessun sovraccarico tipo Electron.",
    feat5_title: "Sospensione disaccoppiata display e CPU",
    feat5_desc: "Lascia riposare lo schermo sulla scrivania mentre i processi continuano.",
    feat6_title: "Privacy e zero telemetria",
    feat6_desc: "Nessun dato raccolto senza consenso. Rispetta la Hardened Runtime.",
    specs_tag: "Ingegneria Nativa",
    specs_title: "Specifiche Tecniche",
    specs_subtitle: "Architettura Swift 6 per la memoria unificata Apple Silicon.",
    spec_k_os: "Compatibilità macOS",
    spec_k_arch: "Architettura",
    spec_k_lang: "Linguaggio e Framework",
    spec_k_footprint: "Dimensioni e RAM",
    spec_k_security: "Sicurezza",
    spec_k_i18n: "Lingue",
    spec_k_distribution: "Distribuzione",
    faq_tag: "Domande e Risposte",
    faq_title: "Domande Frequenti",
    faq_subtitle: "Tutto su sicurezza del display e gestione energetica.",
    faq_q1: "Come spegne lo schermo tenendo sveglio il Mac?",
    faq_a1: "Utilizza le asserzioni IOKit PreventUserIdleSystemSleep e il controllo hardware DisplayServices.",
    faq_q2: "Perché è più sicuro per Liquid Retina?",
    faq_a2: "Perché elimina il calore nocivo intrappolato contro la tastiera a coperchio chiuso.",
    faq_q3: "Scaricamento involontario della batteria?",
    faq_a3: "Impossibile: la protezione automatica disattiva la veglia sotto la soglia impostata.",
    faq_q4: "Serve uno schermo esterno?",
    faq_a4: "No, funziona in autonomia su batteria.",
    faq_q5: "Come installare via Homebrew?",
    faq_a5: "Digita nel Terminale: brew tap UniversalSDK/dopamine && brew install --cask dopamine.",
    cta_title: "Proteggi il tuo Mac. Potenzia il tuo lavoro.",
    cta_desc: "Scarica Dopamine oggi stesso. Prestazioni native al 100%.",
    cta_btn_dmg: "Scarica Dopamine DMG",
    footer_tagline: "Controllo avanzato di alimentazione e display per macOS.",
    footer_downloads: "Download",
    footer_legal: "Note Legali",
    back_to_top: "Torna su",
    toast_copied: "Comando copiato negli appunti!"
  },

  pt: {
    lang_name: "Português",
    nav_comparison: "Comparação",
    nav_interactive: "Demo Interativa",
    nav_features: "Recursos",
    nav_specs: "Especificações",
    nav_faq: "Perguntas",
    nav_download: "Baixar",
    hero_badge: "Pronto para macOS Sequoia • 100% Apple Silicon Nativo",
    hero_title_p1: "Mantenha o seu Mac acordado.",
    hero_title_p2: "Proteja o ecrã Liquid Retina.",
    hero_subtitle: "O utilitário definitivo para macOS. Execute tarefas com a tampa fechada, desligando fisicamente a luz de fundo a 0.0 nits para eliminar o calor acumulado no teclado e ecrã.",
    btn_dmg_title: "Descarregar DMG (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey a Sequoia • 2.6 MB",
    btn_pkg_title: "Descarregar Instalador PKG",
    btn_pkg_sub: "Implantação Empresarial & Administradores",
    brew_label: "Instalar via Homebrew:",
    btn_copy: "Copiar",
    btn_copied: "Copiado!",
    meta_backlight: "Corte de Hardware a 0.0 Nits",
    meta_native: "Swift 6 Nativo • 0% CPU",
    trust_hardened: "Apple Hardened Runtime",
    trust_battery: "Proteção Inteligente de Bateria",
    trust_privacy: "Sem telemetria sem consentimento",
    comp_tag: "Realidade do Hardware",
    comp_title: "Porque os utilitários antigos danificam o seu Mac",
    comp_subtitle: "Ferramentas como o Amphetamine foram criadas para Intel. Em ecrãs Liquid Retina XDR, provocam acumulação perigosa de calor ao fechar a tampa.",
    comp_old_badge: "Utilitários Legados (Amphetamine, Caffeine)",
    comp_old_lid_label: "Tampa fechada: ecrã aceso",
    comp_old_stat_backlight: "Mini-LED retido aceso",
    comp_old_head: "Degradação térmica e desgaste do revestimento",
    comp_old_p1_title: "Calor retido contra as teclas:",
    comp_old_p1_desc: "Os mini-LEDs transmitem calor direto para o teclado, danificando a camada antirreflexo.",
    comp_old_p2_title: "Bateria desperdiçada:",
    comp_old_p2_desc: "Alimentar milhões de subpíxeis sem ninguém ver consome 15–30% a mais por hora.",
    comp_old_p3_title: "Cabos obrigatórios:",
    comp_old_p3_desc: "O sistema Apple exige monitor externo e carregador ligados para não suspender.",
    comp_ag_badge: "Solução Dual-Engine Dopamine",
    comp_ag_lid_label: "Tampa fechada: 0.0 nits reais",
    comp_ag_stat_backlight: "Corte Real por Hardware",
    comp_ag_head: "Silício fresco, trabalho ininterrupto",
    comp_ag_p1_title: "Corte CoreDisplay 0.0 Nits:",
    comp_ag_p1_desc: "Comando IOKit direto que desliga a alimentação dos LEDs no momento em que a tampa fecha.",
    comp_ag_p2_title: "Zero calor nas teclas:",
    comp_ag_p2_desc: "O ecrã permanece frio enquanto o processador Apple Silicon renderiza com desempenho máximo.",
    comp_ag_p3_title: "Clamshell sem fios de verdade:",
    comp_ag_p3_desc: "Sem necessidade de monitores ou cabos. Funcione na bateria com total segurança.",
    demo_tag: "Simulação Interativa em Tempo Real",
    demo_title: "Experimente o menu na barra de ferramentas",
    demo_subtitle: "Clique no ícone do Dopamine abaixo para alternar o estado e trocar os ícones.",
    menu_awake_active: "Dopamine: Sessão Ativa",
    menu_awake_inactive: "Dopamine: Inativo",
    menu_clamshell_safe: "Luz de fundo: 0.0 nits com tampa fechada",
    menu_clamshell_off: "Suspensão normal do macOS",
    menu_duration_title: "Duração da sessão",
    menu_indefinite: "Indefinidamente",
    menu_15m: "Durante 15 minutos",
    menu_1h: "Durante 1 hora",
    menu_2h: "Durante 2 horas",
    menu_cut_backlight: "Desligar tela ao fechar tampa",
    menu_allow_display_sleep: "Permitir repouso de ecrã com CPU ativa",
    menu_battery_guard: "Proteção de bateria: parar abaixo de 10%",
    menu_preferences: "Preferências...",
    menu_disable: "Desativar Dopamine",
    menu_enable: "Ativar Dopamine",
    demo_toggle_hint: "Clique no ícone ou no botão:",
    demo_btn_turn_off: "Tornar inativo",
    demo_btn_turn_on: "Ativar Dopamine",
    demo_icon_style: "Estilo do ícone na barra:",
    feat_tag: "Criado para Apple Silicon",
    feat_title: "Para fluxos profissionais no Mac",
    feat_subtitle: "Engenharia Swift 6 com chamadas diretas IOKit de baixo nível.",
    feat1_title: "0.0 Nits autênticos por hardware",
    feat1_desc: "Não é protetor de ecrã preto: corta fisicamente a energia dos LEDs através do IOKit.",
    feat2_title: "Modo Clamshell sem fios",
    feat2_desc: "Feche o seu MacBook em qualquer lugar usando apenas a bateria.",
    feat3_title: "Proteção automática de bateria",
    feat3_desc: "Finaliza a sessão em níveis críticos para impedir descargas profundas indesejadas.",
    feat4_title: "0.0% CPU e apenas 14 MB de RAM",
    feat4_desc: "100% nativo Swift e AppKit, sem o peso do Electron.",
    feat5_title: "Repouso independente de ecrã e CPU",
    feat5_desc: "Deixe a tela apagar na secretária enquanto os downloads continuam a voar.",
    feat6_title: "Privacidade absoluta",
    feat6_desc: "Sem envio de dados sem a sua autorização. 100% seguro.",
    specs_tag: "Engenharia Nativa",
    specs_title: "Especificações Técnicas",
    specs_subtitle: "Arquitetura Swift 6 desenhada para a memória unificada do Apple Silicon.",
    spec_k_os: "Compatibilidade macOS",
    spec_k_arch: "Arquitetura",
    spec_k_lang: "Linguagem e Frameworks",
    spec_k_footprint: "Tamanho e Memória",
    spec_k_security: "Segurança",
    spec_k_i18n: "Idiomas disponíveis",
    spec_k_distribution: "Formatos de Distribuição",
    faq_tag: "Dúvidas Frequentes",
    faq_title: "Perguntas Frequentes",
    faq_subtitle: "Tudo o que precisa saber sobre segurança de ecrã e gestão de energia.",
    faq_q1: "Como desliga o ecrã mantendo o Mac a funcionar?",
    faq_a1: "Utiliza asserções PreventUserIdleSystemSleep e o protocolo DisplayServices ao fechar a tampa.",
    faq_q2: "Porque é mais seguro para ecrãs Liquid Retina?",
    faq_a2: "Porque elimina o calor gerado pelos mini-LEDs fechados contra as teclas.",
    faq_q3: "Pode esgotar a bateria por engano?",
    faq_a3: "Não, o módulo de bateria encerra a atividade antes de descarregar por completo.",
    faq_q4: "Preciso de um ecrã externo?",
    faq_a4: "Não, funciona com a tampa fechada na bateria sem periféricos.",
    faq_q5: "Como instalar pelo Homebrew?",
    faq_a5: "Execute no Terminal: brew tap UniversalSDK/dopamine && brew install --cask dopamine.",
    cta_title: "Proteja o seu Mac. Acelere a sua produtividade.",
    cta_desc: "Descarregue o Dopamine hoje. Desempenho 100% nativo.",
    cta_btn_dmg: "Descarregar Dopamine DMG",
    footer_tagline: "Controlo de energia e ecrã de última geração para macOS.",
    footer_downloads: "Downloads",
    footer_legal: "Legal",
    back_to_top: "Voltar ao topo",
    toast_copied: "Comando copiado para a área de transferência!"
  },

  ko: {
    lang_name: "한국어",
    nav_comparison: "비교 분석",
    nav_interactive: "인터랙티브 데모",
    nav_features: "주요 기능",
    nav_specs: "기술 사양",
    nav_faq: "자주 묻는 질문",
    nav_download: "다운로드",
    hero_badge: "macOS Sequoia 지원 • 100% Native Apple Silicon",
    hero_title_p1: "Mac을 깨어있게 유지하세요.",
    hero_title_p2: "Liquid Retina 화면을 보호하세요.",
    hero_subtitle: "차세대 macOS 절전 제어 유틸리티. 상판을 닫은 상태에서도 하드웨어 백라이트를 물리적으로 0.0니트까지 완전히 차단하여 키보드 열 축적과 코팅 손상을 방지합니다.",
    btn_dmg_title: "DMG 다운로드 (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey부터 Sequoia • 2.6 MB",
    btn_pkg_title: "PKG 설치 프로그램 다운로드",
    btn_pkg_sub: "기업 및 IT 관리자 배포용",
    brew_label: "Homebrew로 설치:",
    btn_copy: "복사",
    btn_copied: "복사 완료!",
    meta_backlight: "상판 닫을 때 0.0 니트 완전 차단",
    meta_native: "순수 Swift 6 • CPU 0%",
    trust_hardened: "Apple Hardened Runtime 인증",
    trust_battery: "지능형 배터리 보호",
    trust_privacy: "동의 없는 원격 측정 없음",
    comp_tag: "하드웨어 진실 확인",
    comp_title: "기존 도구가 Mac을 손상시키는 이유",
    comp_subtitle: "Amphetamine 같은 기존 도구는 구형 Intel용으로 개발되었습니다. 현대의 Liquid Retina XDR 화면에서는 닫힌 상판 안에서 심각한 열 손상을 일으킵니다.",
    comp_old_badge: "기존 유틸리티 (Amphetamine, Caffeine)",
    comp_old_lid_label: "상판 닫힘: 화면이 계속 켜져 있음",
    comp_old_stat_backlight: "밀폐된 공간의 Mini-LED 고열",
    comp_old_head: "열 축적으로 인한 화면 코팅 손상",
    comp_old_p1_title: "키보드로 전달되는 고열:",
    comp_old_p1_desc: "Liquid Retina XDR의 미니 LED 열이 닫힌 키보드 틈새로 전달되어 반사 방지 코팅 마모를 가속합니다.",
    comp_old_p2_title: "불필요한 배터리 소모:",
    comp_old_p2_desc: "보이지 않는 화면을 위해 수백만 개의 픽셀을 켜둠으로써 시간당 15–30%의 배터리를 낭비합니다.",
    comp_old_p3_title: "강제되는 전원과 외장 모니터:",
    comp_old_p3_desc: "Apple 기본 클램쉘 모드는 충전기와 외장 모니터 연결이 필수입니다.",
    comp_ag_badge: "Dopamine 듀얼 엔진 솔루션",
    comp_ag_lid_label: "상판 닫힘: 하드웨어 0.0 니트",
    comp_ag_stat_backlight: "물리적 전원 차단",
    comp_ag_head: "차가운 화면, 중단 없는 컴퓨팅",
    comp_ag_p1_title: "CoreDisplay 0.0 니트 차단:",
    comp_ag_p1_desc: "상판이 닫히는 즉시 IOKit 하드웨어 레지스터를 호출하여 미니 LED 백라이트 전원을 차단합니다.",
    comp_ag_p2_title: "키보드 전달 열량 제로:",
    comp_ag_p2_desc: "M 시리즈 칩이 백그라운드에서 최대 성능을 발휘하는 동안에도 화면은 차갑게 유지됩니다.",
    comp_ag_p3_title: "진정한 무선 클램쉘 모드:",
    comp_ag_p3_desc: "외부 모니터나 전원 케이블 없이도 배터리 전원만으로 안전하게 작동합니다.",
    demo_tag: "실시간 인터랙티브 시뮬레이션",
    demo_title: "메뉴 막대 앱을 직접 체험해 보세요",
    demo_subtitle: "아래 메뉴 바의 Dopamine 아이콘을 클릭하여 활성화 전환 및 아이콘 변경을 시험해 보세요.",
    menu_awake_active: "Dopamine: 세션 실행 중",
    menu_awake_inactive: "Dopamine: 비활성",
    menu_clamshell_safe: "백라이트: 상판 닫을 때 0.0 니트",
    menu_clamshell_off: "표준 macOS 절전 모드",
    menu_duration_title: "세션 유지 시간",
    menu_indefinite: "무제한 (직접 중지할 때까지)",
    menu_15m: "15분 동안",
    menu_1h: "1시간 동안",
    menu_2h: "2시간 동안",
    menu_cut_backlight: "상판 닫을 때 백라이트 끄기",
    menu_allow_display_sleep: "화면만 끄고 CPU 유지",
    menu_battery_guard: "배터리 보호: 10% 미만 시 중지",
    menu_preferences: "환경설정...",
    menu_disable: "Dopamine 비활성화",
    menu_enable: "Dopamine 활성화",
    demo_toggle_hint: "메뉴 바 아이콘 또는 아래 버튼을 클릭:",
    demo_btn_turn_off: "비활성 상태로 전환",
    demo_btn_turn_on: "활성화하기",
    demo_icon_style: "메뉴 막대 아이콘 스타일 선택:",
    feat_tag: "Apple Silicon 최적화",
    feat_title: "전문가용 Mac 워크플로우를 위한 설계",
    feat_subtitle: "하드웨어 수명을 보호하면서 완벽한 성능을 내도록 Swift 6과 IOKit API로 제작되었습니다.",
    feat1_title: "물리적 0.0 니트 하드웨어 블랙아웃",
    feat1_desc: "단순한 검은색 화면이 아니라, IOKit을 통해 백라이트 LED로 가는 전류를 직접 차단합니다.",
    feat2_title: "완전 무선 클램쉘 모드",
    feat2_desc: "충전기나 모니터 연결 없이 이동 중에도 상판을 닫고 작업을 실행할 수 있습니다.",
    feat3_title: "지능형 배터리 자동 보호",
    feat3_desc: "배터리가 설정한 임계값(예: 10%) 이하로 떨어지면 자동으로 절전을 허용하여 방전을 방지합니다.",
    feat4_title: "유휴 CPU 0.0% & 메모리 14MB",
    feat4_desc: "순수 네이티브 Swift와 AppKit으로 작성되어 Electron의 비효율이 없습니다.",
    feat5_title: "화면과 CPU의 독립적 절전 분리",
    feat5_desc: "책상 위에서 화면은 절전 상태로 두면서 렌더링과 다운로드는 계속 유지하세요.",
    feat6_title: "완벽한 프라이버시 & 무원격 측정",
    feat6_desc: "명시적 동의 없는 데이터 수집은 일절 없습니다. 설정은 로컬에 안전하게 저장됩니다.",
    specs_tag: "네이티브 엔지니어링",
    specs_title: "기술 사양",
    specs_subtitle: "Apple Silicon의 통합 메모리 아키텍처에 맞춘 순수 Swift 6 설계.",
    spec_k_os: "macOS 호환성",
    spec_k_arch: "하드웨어 아키텍처",
    spec_k_lang: "언어 및 프레임워크",
    spec_k_footprint: "용량 및 메모리",
    spec_k_security: "보안 및 공증",
    spec_k_i18n: "지원 언어",
    spec_k_distribution: "배포 형식",
    faq_tag: "궁금한 점이 있으신가요?",
    faq_title: "자주 묻는 질문 (FAQ)",
    faq_subtitle: "화면 보호 및 전원 제어 기술에 대한 상세한 답변입니다.",
    faq_q1: "Mac을 깨운 채로 화면 백라이트만 끄는 원리는 무엇인가요?",
    faq_a1: "IOKit의 PreventUserIdleSystemSleep으로 프로세스를 유지하면서, 상판 닫힘 이벤트 시 DisplayServices를 호출하여 백라이트 전원을 물리적으로 차단합니다.",
    faq_q2: "Liquid Retina 화면에 왜 더 안전한가요?",
    faq_a2: "상판을 닫았을 때 키보드와 맞닿아 발생하는 Mini-LED의 열 축적을 원천적으로 없애주기 때문입니다.",
    faq_q3: "가방 안에서 배터리가 방전되지 않나요?",
    faq_a3: "배터리 보호 기능이 10% 미만에서 자동으로 절전 해제를 수행하므로 안심할 수 있습니다.",
    faq_q4: "외장 모니터가 필요한가요?",
    faq_a4: "필요 없습니다. 충전기나 모니터 없이 배터리만으로 상판을 닫고 사용할 수 있습니다.",
    faq_q5: "Homebrew 설치 방법은?",
    faq_a5: "터미널에서 brew tap UniversalSDK/dopamine && brew install --cask dopamine 를 입력하면 됩니다.",
    cta_title: "당신의 Mac을 보호하고 생산성을 극대화하세요.",
    cta_desc: "지금 Dopamine를 다운로드하세요. Apple Silicon을 위한 100% 네이티브 성능.",
    cta_btn_dmg: "Dopamine DMG 다운로드",
    footer_tagline: "macOS를 위한 차세대 디스플레이 및 전원 제어 유틸리티.",
    footer_downloads: "다운로드",
    footer_legal: "법적 고지",
    back_to_top: "맨 위로 이동",
    toast_copied: "명령어가 클립보드에 복사되었습니다!"
  },

  ru: {
    lang_name: "Русский",
    nav_comparison: "Сравнение",
    nav_interactive: "Интерактивное демо",
    nav_features: "Возможности",
    nav_specs: "Спецификации",
    nav_faq: "Частые вопросы",
    nav_download: "Скачать",
    hero_badge: "Готово для macOS Sequoia • 100% Native Apple Silicon",
    hero_title_p1: "Держите Mac бодрствующим.",
    hero_title_p2: "Защитите экран Liquid Retina.",
    hero_subtitle: "Совершенная двухъядерная утилита для macOS. Запускайте долгий рендеринг, сборку кода и загрузки с закрытой крышкой — с аппаратным отключением подсветки до абсолютных 0.0 нит для защиты от теплового перегрева матрицы.",
    btn_dmg_title: "Скачать DMG (Apple Silicon)",
    btn_dmg_sub: "v1.2.0 • macOS 12+ Monterey до Sequoia • 2.6 МБ",
    btn_pkg_title: "Скачать установщик PKG",
    btn_pkg_sub: "Корпоративное и системное развертывание",
    brew_label: "Установка через Homebrew:",
    btn_copy: "Копировать",
    btn_copied: "Скопировано!",
    meta_backlight: "Аппаратные 0.0 нит при закрытии",
    meta_native: "Нативный Swift 6 • 0% CPU",
    trust_hardened: "Apple Hardened Runtime",
    trust_battery: "Умная защита аккумулятора",
    trust_privacy: "Ноль телеметрии без согласия",
    comp_tag: "Аппаратная реальность",
    comp_title: "Почему старые утилиты вредят вашему Mac",
    comp_subtitle: "Инструменты вроде Amphetamine и Caffeine создавались для процессоров Intel. На современных дисплеях Liquid Retina XDR они превращают закрытый ноутбук в тепловую ловушку.",
    comp_old_badge: "Устаревшие утилиты (Amphetamine, Caffeine)",
    comp_old_lid_label: "Крышка закрыта: Экран светит под клавиатурой",
    comp_old_stat_backlight: "Зажатая подсветка Mini-LED",
    comp_old_head: "Термическая деградация и риск отслоения",
    comp_old_p1_title: "Тепло зажато возле клавиш:",
    comp_old_p1_desc: "Мини-диоды Liquid Retina XDR излучают тепло прямо в закрытые клавиши, разрушая антибликовое покрытие.",
    comp_old_p2_title: "Бесполезный расход аккумулятора:",
    comp_old_p2_desc: "Питание миллионов субпикселей на невидимом закрытом экране тратит на 15–30% больше энергии в час.",
    comp_old_p3_title: "Принудительные провода для Clamshell:",
    comp_old_p3_desc: "Стандартный режим Apple требует подключения внешнего монитора и зарядки даже для простых фоновых задач.",
    comp_ag_badge: "Двухдвижковое решение Dopamine",
    comp_ag_lid_label: "Крышка закрыта: Аппаратные 0.0 нит",
    comp_ag_stat_backlight: "Настоящее обесточивание экрана",
    comp_ag_head: "Холодный процессор, непрерывная работа",
    comp_ag_p1_title: "Аппаратное отключение CoreDisplay:",
    comp_ag_p1_desc: "Прямой вызов регистров IOKit обесточивает светодиоды подсветки в момент закрытия крышки.",
    comp_ag_p2_title: "Ноль тепловой нагрузки на матрицу:",
    comp_ag_p2_desc: "Дисплей Liquid Retina остается холодным, пока чип Apple Silicon рендерит или компилирует на полной мощности.",
    comp_ag_p3_title: "Настоящий Clamshell без проводов:",
    comp_ag_p3_desc: "Никаких внешних экранов и зарядных устройств. Безопасная работа в рюкзаке или в дороге.",
    demo_tag: "Живая интерактивная симуляция",
    demo_title: "Попробуйте меню приложения прямо сейчас",
    demo_subtitle: "Нажмите на иконку Dopamine в строке меню ниже, чтобы включить активный режим, сменить иконку и протестировать нативное меню.",
    menu_awake_active: "Dopamine: Сессия активна",
    menu_awake_inactive: "Dopamine: Неактивен",
    menu_clamshell_safe: "Подсветка: 0.0 нит при закрытии",
    menu_clamshell_off: "Стандартная политика сна macOS",
    menu_duration_title: "Длительность сессии",
    menu_indefinite: "Бессрочно (до отключения)",
    menu_15m: "На 15 минут",
    menu_1h: "На 1 час",
    menu_2h: "На 2 часа",
    menu_cut_backlight: "Выключать подсветку при закрытии крышки",
    menu_allow_display_sleep: "Разрешить сон экрана при бодрствующем CPU",
    menu_battery_guard: "Защита батареи: остановка ниже 10%",
    menu_preferences: "Настройки...",
    menu_disable: "Деактивировать Dopamine",
    menu_enable: "Активировать Dopamine",
    demo_toggle_hint: "Нажмите на иконку в строке меню или воспользуйтесь кнопкой:",
    demo_btn_turn_off: "Переключить в неактивное состояние",
    demo_btn_turn_on: "Активировать Dopamine",
    demo_icon_style: "Выберите стиль иконки в строке меню:",
    feat_tag: "Создано для Apple Silicon",
    feat_title: "Инструмент для профессиональных рабочих задач",
    feat_subtitle: "Каждая функция написана на Swift 6 с низкоуровневыми API IOKit для максимальной энергоэффективности.",
    feat1_title: "Настоящее обесточивание 0.0 нит",
    feat1_desc: "Это не черная заставка. Это физическое отключение контроллера подсветки Mini-LED/OLED через IOKit DisplayServices.",
    feat2_title: "Беспроводной режим Clamshell",
    feat2_desc: "Dopamine снимает ограничения Apple, позволяя закрывать крышку при работе от батареи без внешних экранов.",
    feat3_title: "Автоматическая защита аккумулятора",
    feat3_desc: "Укажите порог (например, 10%). При его достижении удержание сна снимется, спасая Mac от глубокого разряда.",
    feat4_title: "0.0% CPU и всего 14 МБ памяти",
    feat4_desc: "100% чистый нативный Swift и AppKit. Никакого Electron и прожорливых фоновых процессов.",
    feat5_title: "Раздельный сон экрана и системы",
    feat5_desc: "Экран может гаснуть для экономии ресурса на столе, пока процессор и сеть продолжают выполнять вычисления.",
    feat6_title: "Приватность и ноль телеметрии",
    feat6_desc: "Никакого сбора данных без вашего явного согласия. Полное соответствие Apple Hardened Runtime.",
    specs_tag: "Нативная инженерия",
    specs_title: "Технические характеристики",
    specs_subtitle: "Архитектура Swift 6, оптимизированная под объединенную память чипов Apple Silicon.",
    spec_k_os: "Совместимость с macOS",
    spec_k_arch: "Архитектура",
    spec_k_lang: "Язык и фреймворки",
    spec_k_footprint: "Размер и память",
    spec_k_security: "Безопасность",
    spec_k_i18n: "Поддерживаемые языки",
    spec_k_distribution: "Форматы дистрибуции",
    faq_tag: "Есть вопросы?",
    faq_title: "Часто задаваемые вопросы",
    faq_subtitle: "Все о безопасности дисплея, управлении питанием и установке утилиты.",
    faq_q1: "Как Dopamine гасит экран, сохраняя активность Mac?",
    faq_a1: "Dopamine создает системное утверждение PreventUserIdleSystemSleep в IOKit, одновременно перехватывая датчик крышки. При закрытии вызывается низкоуровневая команда DisplayServices, обесточивающая диоды подсветки.",
    faq_q2: "Почему Dopamine безопаснее для Liquid Retina, чем аналоги?",
    faq_a2: "Экраны Liquid Retina XDR состоят из тысяч ярких мини-диодов. Если крышка закрыта, а диоды светят, тепло разрушает антибликовое покрытие клавишами. Dopamine гасит диоды на 100%.",
    faq_q3: "Может ли Dopamine разрядить ноутбук в рюкзаке?",
    faq_a3: "Нет. Встроенный модуль контроля батареи автоматически снимает удержание активности при падении заряда ниже установленного порога (например, 10%).",
    faq_q4: "Нужен ли внешний монитор для закрытой крышки?",
    faq_a4: "Нет! В отличие от стандартного ограничения Apple, Dopamine позволяет закрывать крышку без подключенных проводов.",
    faq_q5: "Как установить Dopamine через Homebrew?",
    faq_a5: "Откройте Терминал и выполните: brew tap UniversalSDK/dopamine && brew install --cask dopamine. Homebrew автоматически проверит контрольные суммы SHA-256.",
    cta_title: "Защитите свой Mac. Ускорьте продуктивность.",
    cta_desc: "Скачайте Dopamine сегодня. Чистая нативная скорость Apple Silicon.",
    cta_btn_dmg: "Скачать Dopamine DMG",
    footer_tagline: "Контроллер питания и дисплея нового поколения для macOS.",
    footer_downloads: "Загрузки",
    footer_legal: "Правовая информация",
    back_to_top: "Наверх",
    toast_copied: "Команда скопирована в буфер обмена!"
  }
};

// ==========================================================================
// 2. STATE & INITIALIZATION
// ==========================================================================
let currentLanguage = 'en';
let isSessionActive = true;
let currentIconStyle = 'eye';
let currentIconSymbol = '👁️';
let timerSeconds = 6322; // 01:45:22 initial demo value
let timerInterval = null;

// GA4 Tracker Helper
function trackEvent(eventName, params = {}) {
  try {
    if (typeof gtag === 'function') {
      gtag('event', eventName, params);
      console.log(`[GA4 Tracked]: ${eventName}`, params);
    }
  } catch (e) {
    console.warn('[GA4 Track Error]:', e);
  }
}

// ==========================================================================
// 3. i18n ENGINE
// ==========================================================================
function detectInitialLanguage() {
  const saved = localStorage.getItem('dopamine_lang');
  if (saved && i18nData[saved]) {
    return saved;
  }
  
  const browserLangs = navigator.languages || [navigator.language || 'en'];
  for (const bLang of browserLangs) {
    const code = bLang.toLowerCase().slice(0, 2);
    if (i18nData[code]) {
      return code;
    }
  }
  return 'en';
}

function applyLanguage(langCode) {
  if (!i18nData[langCode]) langCode = 'en';
  currentLanguage = langCode;
  localStorage.setItem('dopamine_lang', langCode);
  document.documentElement.lang = langCode;

  const dict = i18nData[langCode];

  // Update all data-i18n elements
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (dict[key]) {
      el.textContent = dict[key];
    }
  });

  // Update dropdown button label
  const labelEl = document.getElementById('currentLangLabel');
  if (labelEl && dict.lang_name) {
    labelEl.textContent = dict.lang_name;
  }

  // Update active state in dropdown
  document.querySelectorAll('.lang-option').forEach(btn => {
    btn.classList.toggle('active', btn.getAttribute('data-lang') === langCode);
  });

  // Update dynamic state text inside menu if needed
  updateMenuStateDisplay();

  trackEvent('language_change', { language: langCode });
}

// ==========================================================================
// 4. INTERACTIVE MENUBAR MOCKUP
// ==========================================================================
function formatTime(seconds) {
  const h = Math.floor(seconds / 3600).toString().padStart(2, '0');
  const m = Math.floor((seconds % 3600) / 60).toString().padStart(2, '0');
  const s = (seconds % 60).toString().padStart(2, '0');
  return `${h}:${m}:${s}`;
}

function updateMenuStateDisplay() {
  const dict = i18nData[currentLanguage] || i18nData.en;
  const itemEl = document.getElementById('menuItemDopamine');
  const timerText = document.getElementById('menubarTimerText');
  const dotEl = document.getElementById('dropdownStatusDot');
  const stateTitle = document.getElementById('dropdownStateTitle');
  const stateDesc = document.getElementById('dropdownStateDesc');
  const toggleLabel = document.getElementById('menuToggleStateLabel');
  const btnSimText = document.getElementById('btnSimStateText');

  if (isSessionActive) {
    itemEl.classList.add('active');
    dotEl.classList.add('active');
    timerText.style.display = 'inline';
    timerText.textContent = formatTime(timerSeconds);
    stateTitle.textContent = dict.menu_awake_active;
    stateDesc.textContent = dict.menu_clamshell_safe;
    toggleLabel.textContent = dict.menu_disable;
    btnSimText.textContent = dict.demo_btn_turn_off;
  } else {
    itemEl.classList.remove('active');
    dotEl.classList.remove('active');
    timerText.style.display = 'none';
    stateTitle.textContent = dict.menu_awake_inactive;
    stateDesc.textContent = dict.menu_clamshell_off;
    toggleLabel.textContent = dict.menu_enable;
    btnSimText.textContent = dict.demo_btn_turn_on;
  }
}

function toggleSessionState() {
  isSessionActive = !isSessionActive;
  updateMenuStateDisplay();
  trackEvent('menubar_interactive_toggle', { active: isSessionActive });
}

function setupMenuBarDemo() {
  const itemTrigger = document.getElementById('menuItemDopamine');
  const popover = document.getElementById('macDropdownMenu');
  const btnSimToggle = document.getElementById('btnToggleSimState');
  const menuToggleState = document.getElementById('menuToggleState');
  const iconChoiceBtns = document.querySelectorAll('.btn-icon-choice');
  const activeIconEl = document.getElementById('menubarActiveIcon');

  // Timer interval countup
  if (timerInterval) clearInterval(timerInterval);
  timerInterval = setInterval(() => {
    if (isSessionActive) {
      timerSeconds++;
      const timerText = document.getElementById('menubarTimerText');
      if (timerText) timerText.textContent = formatTime(timerSeconds);
    }
  }, 1000);

  // Click on status item to toggle dropdown
  itemTrigger.addEventListener('click', (e) => {
    e.stopPropagation();
    popover.classList.toggle('open');
  });

  // Close dropdown on outside click
  document.addEventListener('click', (e) => {
    if (!popover.contains(e.target) && !itemTrigger.contains(e.target)) {
      popover.classList.remove('open');
    }
  });

  // Toggle button in mockup footer
  btnSimToggle.addEventListener('click', () => {
    toggleSessionState();
  });

  // Toggle from inside menu
  menuToggleState.addEventListener('click', () => {
    toggleSessionState();
  });

  // Icon style switcher
  iconChoiceBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      iconChoiceBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      currentIconStyle = btn.getAttribute('data-icon');
      currentIconSymbol = btn.getAttribute('data-symbol');
      activeIconEl.textContent = currentIconSymbol;
      trackEvent('icon_style_select', { icon: currentIconStyle });
    });
  });

  // Presets click in dropdown
  popover.querySelectorAll('[data-action]').forEach(item => {
    item.addEventListener('click', () => {
      popover.querySelectorAll('[data-action]').forEach(el => {
        el.classList.remove('active');
        el.querySelector('.item-check').textContent = '';
      });
      item.classList.add('active');
      item.querySelector('.item-check').textContent = '✓';
    });
  });

  // Checkbox toggles in dropdown
  ['menuToggleClamshell', 'menuToggleAllowSleep', 'menuToggleBatterySafeguard'].forEach(id => {
    const el = document.getElementById(id);
    if (el) {
      el.addEventListener('click', () => {
        const check = el.querySelector('.item-check');
        check.textContent = (check.textContent === '✓') ? '' : '✓';
      });
    }
  });

  // Update Mac clock in menu bar
  const clockEl = document.getElementById('macClockTime');
  if (clockEl) {
    const updateClock = () => {
      const now = new Date();
      const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      const day = days[now.getDay()];
      const hrs = now.getHours().toString().padStart(2, '0');
      const mins = now.getMinutes().toString().padStart(2, '0');
      clockEl.textContent = `${day} ${hrs}:${mins}`;
    };
    updateClock();
    setInterval(updateClock, 30000);
  }
}

// ==========================================================================
// 5. COPY TO CLIPBOARD & TOAST
// ==========================================================================
function copyTextToClipboard(text, successCallback) {
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(text).then(successCallback).catch(() => {
      fallbackCopy(text, successCallback);
    });
  } else {
    fallbackCopy(text, successCallback);
  }
}

function fallbackCopy(text, successCallback) {
  const textarea = document.createElement('textarea');
  textarea.value = text;
  textarea.style.position = 'fixed';
  textarea.style.opacity = '0';
  document.body.appendChild(textarea);
  textarea.select();
  try {
    document.execCommand('copy');
    if (successCallback) successCallback();
  } catch (err) {
    console.error('Copy fallback failed', err);
  }
  document.body.removeChild(textarea);
}

function showToast(message) {
  const toast = document.getElementById('toastNotification');
  const msgEl = document.getElementById('toastMessage');
  if (!toast || !msgEl) return;
  msgEl.textContent = message;
  toast.classList.add('show');
  setTimeout(() => {
    toast.classList.remove('show');
  }, 2600);
}

function setupCopyHandlers() {
  const btnCopyBrew = document.getElementById('btnCopyBrew');
  const btnCopyBrewFooter = document.getElementById('btnCopyBrewFooter');
  const brewCmd = 'brew tap UniversalSDK/dopamine && brew install --cask dopamine';
  const dict = () => i18nData[currentLanguage] || i18nData.en;

  const onCopySuccess = () => {
    showToast(dict().toast_copied);
    trackEvent('brew_copy_click', { command: brewCmd });

    const heroCopyBtn = document.getElementById('copyBtnText');
    if (heroCopyBtn) {
      heroCopyBtn.textContent = dict().btn_copied;
      setTimeout(() => {
        heroCopyBtn.textContent = dict().btn_copy;
      }, 2000);
    }

    const footerPill = document.getElementById('footerCopyPill');
    if (footerPill) {
      footerPill.textContent = dict().btn_copied;
      setTimeout(() => {
        footerPill.textContent = dict().btn_copy;
      }, 2000);
    }
  };

  if (btnCopyBrew) {
    btnCopyBrew.addEventListener('click', () => {
      copyTextToClipboard(brewCmd, onCopySuccess);
    });
  }

  if (btnCopyBrewFooter) {
    btnCopyBrewFooter.addEventListener('click', () => {
      copyTextToClipboard(brewCmd, onCopySuccess);
    });
  }
}

// ==========================================================================
// 6. DOWNLOAD CLICKS GA4 TRACKING
// ==========================================================================
function setupDownloadTracking() {
  const dmgBtns = [
    document.getElementById('btnDownloadDmg'),
    document.getElementById('btnDownloadDmgFooter')
  ];
  dmgBtns.forEach(btn => {
    if (btn) {
      btn.addEventListener('click', () => {
        trackEvent('download_dmg_click', {
          version: '1.2.0',
          file: 'Dopamine.dmg'
        });
      });
    }
  });

  const pkgBtn = document.getElementById('btnDownloadPkg');
  if (pkgBtn) {
    pkgBtn.addEventListener('click', () => {
      trackEvent('download_pkg_click', {
        version: '1.2.0',
        file: 'Dopamine-Installer.pkg'
      });
    });
  }
}

// ==========================================================================
// 7. FAQ ACCORDION
// ==========================================================================
function setupFaqAccordion() {
  document.querySelectorAll('.faq-question').forEach(btn => {
    btn.addEventListener('click', () => {
      const item = btn.closest('.faq-item');
      const isOpen = item.classList.contains('open');

      // Close other items
      document.querySelectorAll('.faq-item').forEach(other => {
        if (other !== item) other.classList.remove('open');
      });

      item.classList.toggle('open', !isOpen);
      btn.setAttribute('aria-expanded', !isOpen);
    });
  });
}

// ==========================================================================
// 8. 3D PARALLAX TILT FOR HERO ICON
// ==========================================================================
function setupParallaxTilt() {
  const card = document.getElementById('heroIconTilt');
  if (!card) return;

  card.addEventListener('mousemove', (e) => {
    const rect = card.getBoundingClientRect();
    const x = e.clientX - rect.left - rect.width / 2;
    const y = e.clientY - rect.top - rect.height / 2;
    const rotX = (y / (rect.height / 2)) * -12;
    const rotY = (x / (rect.width / 2)) * 12;
    card.style.transform = `perspective(1000px) rotateX(${rotX}deg) rotateY(${rotY}deg) scale3d(1.04, 1.04, 1.04)`;
  });

  card.addEventListener('mouseleave', () => {
    card.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)';
  });
}

// ==========================================================================
// 9. LANGUAGE DROPDOWN & MOBILE MENU
// ==========================================================================
function setupNavigation() {
  const langBtn = document.getElementById('langDropdownBtn');
  const langMenu = document.getElementById('langDropdownMenu');

  if (langBtn && langMenu) {
    langBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      langMenu.classList.toggle('open');
      langBtn.setAttribute('aria-expanded', langMenu.classList.contains('open'));
    });

    document.querySelectorAll('.lang-option').forEach(opt => {
      opt.addEventListener('click', (e) => {
        e.stopPropagation();
        const code = opt.getAttribute('data-lang');
        applyLanguage(code);
        langMenu.classList.remove('open');
        langBtn.setAttribute('aria-expanded', false);
      });
    });

    document.addEventListener('click', (e) => {
      if (!langMenu.contains(e.target) && !langBtn.contains(e.target)) {
        langMenu.classList.remove('open');
        langBtn.setAttribute('aria-expanded', false);
      }
    });
  }

  // Mobile Drawer Toggle
  const mobToggle = document.getElementById('mobileNavToggle');
  const mobDrawer = document.getElementById('mobileDrawer');
  if (mobToggle && mobDrawer) {
    mobToggle.addEventListener('click', () => {
      mobDrawer.classList.toggle('open');
    });

    mobDrawer.querySelectorAll('.mobile-link').forEach(link => {
      link.addEventListener('click', () => {
        mobDrawer.classList.remove('open');
      });
    });
  }
}

// ==========================================================================
// DOMContentLoaded Entrypoint
// ==========================================================================
document.addEventListener('DOMContentLoaded', () => {
  const initialLang = detectInitialLanguage();
  applyLanguage(initialLang);

  setupNavigation();
  setupMenuBarDemo();
  setupCopyHandlers();
  setupDownloadTracking();
  setupFaqAccordion();
  setupParallaxTilt();

  console.log('⚡ Dopamine Landing Page initialized successfully with 11 languages.');
});
