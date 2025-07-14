# HYF Parents App - Requirements

## Overview

**App Name:** HYF Parents  
**Technology Stack:** Swift (iOS), React Native + Fluent UI v9 (noted in implementation plan), Supabase (database)  
**Purpose:** Provide Huntley Youth Football (HYF) parents and fans with convenient access to resources, schedules, weather alerts, registration, rules, and other essential information, all in a responsive mobile app.

**Intended Users:**  

- Parents of HYF participants  
- Fans of HYF  
- League participants (Tackle, 7v7, Girls Flag Football)  

---

## Functional Requirements

### 1. Home Screen Features

- **Football Field Background and HYF Branding:**  
  - Displays a branded image background and logo.

- **Quick Access Buttons:**  
  - Calendar (Important Dates): Links to the HYF calendar.
  - Weather Alert: Links to a live weather advisory widget.
  - Registration: Directs users to the registration page.
  - Spirit Store: Directs users to the merchandise store.
  - TCYFL Website: Directs users to the league’s main website.

### 2. Tab-Based Navigation

- **Home:**  
  - MainScreenView with quick access icons.

- **Tackle Tab:**  
  - League Calendar: Links to tackle football calendar.
  - Field Maps: Placeholder for future maps.
  - League Rules: PDF previewer for TCYFL tackle football rules.
  - VEO Camera Link: Placeholder for future feature.

- **7v7 Tab:**  
  - League Calendar: Links to 7v7 football calendar.
  - Field Maps: Placeholder for future maps.
  - League Rules: PDF previewer for K-3 and 5-8 rules.

- **Girls Flag Tab:**  
  - League Calendar: Placeholder for future calendar.
  - Field Maps: Placeholder for future maps.
  - League Rules: PDF previewer for Girls Flag Football rules.

### 3. PDF Preview Functionality

- **PDF Search:**  
  - Users can search within league rules PDFs.
  - Navigation for search results (Prev/Next).

### 4. External Web Views

- **Weather Widget:**  
  - Embedded web view for live weather alerts (optional, replaced by icon button).

## Non-Functional Requirements

- **Responsive UI:**  
  - Layout adapts to different iOS devices.
  - Uses tab navigation and grid for icon buttons.

- **Accessibility:**  
  - Buttons have accessibility labels.
  - Visuals and navigation follow iOS conventions.

- **Performance:**  
  - Fast loading of PDFs and web content.
  - Efficient tab switching.

## Future Enhancements

- Add field maps for all divisions.
- Add VEO camera link integration.
- Complete calendar and map features for Girls Flag and 7v7.
- Expand Supabase database integration (not currently visible in Swift code).
- Add push notifications for alerts or important dates.

---

## External Resources

- [HYF Important Dates](https://www.huntleyyouthfootball.org/page/show/6967331-important-dates)
- [HYF Registration](https://www.huntleyyouthfootball.org/page/show/6967329-registration)
- [HYF Spirit Store](https://www.huntleyyouthfootball.org/spiritstore)
- [TCYFL League Website](https://www.tcyfl.net/index.php)
- [Weather Widget](https://widget.perryweather.com/?id=e2f730aa-4287-41fe-aec3-abae3744f3e0)
- [TCYFL Tackle Rules PDF](https://www.tcyfl.net/grabit.php?file=TCYFL_Football_Playing_Rules_FINAL.pdf)
- [TCYFL K-3 Rules PDF](https://www.tcyfl.net/grabit.php?file=2025FINALK3_rules.pdf)
- [TCYFL 7v7 Rules PDF](https://www.tcyfl.net/grabit.php?file=2025FINAL7_7_rules.pdf)
- [TCYFL Girls Flag Rules PDF](https://www.tcyfl.net/grabit.php?file=TCYFL_Girls_Fall_Flag_Rules_2024.pdf)

---

## References

- [Implementation Plan](./Implementtion_Plan.md)
