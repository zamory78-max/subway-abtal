# سابواي الأبطال 3D — تطبيق أندرويد

هذا مشروع أندرويد كامل يحوّل اللعبة إلى تطبيق حقيقي (APK) يعمل **بدون إنترنت**، بملء الشاشة، مع دعم زر الرجوع والاهتزاز والإيقاف التلقائي عند الخروج.

ملف اللعبة نفسه موجود في: `app/src/main/assets/www/index.html`

---

## الطريقة 1 (الأسهل، بدون تثبيت أي برنامج): البناء السحابي عبر GitHub

1. أنشئ حساباً مجانياً على [github.com](https://github.com) ثم اضغط **New repository** (اجعله Public أو Private).
2. ارفع **كل محتويات هذا المجلد** (بما فيها المجلد المخفي `.github`) — أسهل طريقة: تطبيق GitHub Desktop، أو زر **Add file ‣ Upload files** في الموقع.
   - ملاحظة: الرفع من المتصفح قد يتجاهل المجلدات المخفية؛ إن حدث ذلك أنشئ الملف `.github/workflows/build-apk.yml` يدوياً بالضغط على **Add file ‣ Create new file** والصق محتواه.
3. افتح تبويب **Actions** في المستودع؛ سيبدأ البناء تلقائياً (أو اضغط **Run workflow**).
4. بعد 5–8 دقائق، افتح عملية البناء الخضراء ✅ وحمّل **SubwayAbtal-APK** من قسم Artifacts.
5. فك الضغط، انقل ملف `app-release.apk` إلى هاتفك وثبّته (اسمح بـ "التثبيت من مصادر غير معروفة" إذا طُلب منك).

## الطريقة 2: عبر Android Studio على جهازك

1. ثبّت [Android Studio](https://developer.android.com/studio).
2. نزّل مكتبات اللعبة مرة واحدة (يحتاج إنترنت):
   - **ويندوز:** انقر مرتين على `tools\download-libs.bat`
   - **ماك / لينكس:** `bash tools/download-libs.sh`
3. افتح Android Studio ‣ **Open** ‣ اختر هذا المجلد وانتظر انتهاء المزامنة (Gradle Sync).
4. من القائمة: **Build ‣ Build App Bundle(s) / APK(s) ‣ Build APK(s)**.
5. ستجد الملف في `app/build/outputs/apk/`، أو وصّل هاتفك بكابل USB واضغط ▶️ Run للتثبيت مباشرة.

> ⚠️ إذا نسيت خطوة تنزيل المكتبات سيعمل التطبيق فقط عند الاتصال بالإنترنت (يحمّلها من الشبكة تلقائياً).

---

## تعديل اللعبة لاحقاً
- عدّل الملف `app/src/main/assets/www/index.html` ثم أعد البناء.
- يمكنك تجربة الملف مباشرة في متصفح Chrome على الكمبيوتر قبل البناء.

## تخصيصات مفيدة
| ما تريد تغييره | أين |
|---|---|
| اسم التطبيق | `app/src/main/res/values/strings.xml` |
| اتجاه الشاشة (حالياً عمودي) | `android:screenOrientation` في `AndroidManifest.xml` (مثلاً `sensorLandscape` أو `fullSensor`) |
| أيقونة التطبيق | ملفات `ic_launcher*.png` داخل مجلدات `mipmap-*` |
| رقم الإصدار | `versionCode` و `versionName` في `app/build.gradle` |

## النشر على Google Play
ملف الـ APK الحالي موقّع بمفتاح تجريبي (debug) ليُثبَّت مباشرة على أي هاتف. للنشر على Google Play:
1. في Android Studio: **Build ‣ Generate Signed App Bundle / APK** ‣ أنشئ مفتاحك الخاص واحفظه جيداً (لا يمكن استبداله لاحقاً).
2. ارفع ملف `.aab` الناتج إلى [Google Play Console](https://play.google.com/console).
3. غيّر `applicationId` في `app/build.gradle` إلى معرف فريد خاص بك (مثل `com.yourname.subway`) قبل أول نشر.

## المواصفات التقنية
- Android 7.0 (API 24) فما فوق، الهدف API 35.
- WebView مع WebViewAssetLoader (حفظ النتائج والعملات يعمل بشكل دائم).
- اللعبة: Three.js r128 مع إضاءة واقعية (ACES + ظلال + انعكاسات بيئية).
