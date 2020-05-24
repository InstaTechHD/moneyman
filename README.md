# MoneyMan

MoneyMan aims to be a fully cross-platform, open source, app for personal bookkeeping. The main goal is to have a shared
codebase/UI that can be used on smartphones, desktops, and web. The framework [Flutter](https://flutter.dev/) will be
the key to achieving that. Furthermore, it should be possible to easily sync data to a server (which will act as the
back-end to the web app) and to multiple devices. Initially, only Android and Linux will be officially supported/tested.
Sync as well as web support will only be on the distant horizon for now.

The main motivation for building MoneyMan is that there is currently no application like it on the market. All the ones
I have come across are often very dated, limited in their functionality, not offline-first, and not cross-platform
between smartphones and desktop/web. On top of that, they're rarely open source.

The main source for inspiration will be the fantastic Android app anMoney. It has a lot of useful features as well as
decent UI layouts. Unfortunately, it has not been actively developed since 2014, it was not open source, and the
developer disappeared. Ultimately, it should be easy for an anMoney user to transition to MoneyMan.

Since this is purely a hobby project, there is no timeline for how long it will take to develop all the necessary
features for the app to be fully useable, but it is expected to take more than a year.

## Initial Goals & Features

* Support Android, Linux, and Windows
* Full offline support
* Multiple accounts with different currencies
* Budgeting
  * On a per-category basis
  * Common intervals as well as fixed amounts for specific periods 
    (e.g. $100 for March, $150 for April, etc.)
  * Exlude specific transactions and categories from the budget
* Recurring transactions
  * Common schedules
  * Optionally automatically included/excluded from budget
* Loans/liabilities management
  * Clearly see and track who you owe money as well as who owes you money
  
  
## Long-term Goals & Features

* Support Android, iOS, Linux, Windows, macOS, and web
* Synchronize all the data to a remote server and other devices
* Alternative UI layout for screens that are larger than a smartphone screen (e.g. tablets, desktops, and web)
