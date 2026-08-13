# التشغيل الآمن لمسار CI/CD

**إعداد فريق تطوير مشروع جناح الحنين**

## المسارات المتاحة

يحتوي المستودع على مسارين منفصلين. يعمل `Flutter CI` على كل طلب دمج متجه إلى `main` أو `develop` وعلى كل دفع مباشر إليهما، وهو المرجع الوحيد لفحص التنسيق والتحليل والاختبارات السريعة. يعمل `Release validation` يدوياً أو عند دفع وسم مطابق لـ `v*.*.*`، ويعيد تشغيل بوابة الجودة ثم يشغل اختبارات التكامل ويبني Android App Bundle ويحفظه كـ artifact لمدة 14 يوماً.

| الملف | الاستخدام | النتيجة |
|---|---|---|
| `.github/workflows/flutter_ci.yml` | Pull Request، دفع للفروع المحمية، أو تشغيل يدوي | الحالة المطلوبة `Flutter CI / build` |
| `.github/workflows/release_validation.yml` | تشغيل يدوي أو وسم إصدار | AAB قابل للتنزيل، من دون نشر تلقائي |
| `tool/verify_flutter.sh` | المصدر الموحد للتحقق محلياً وبعيداً | تنسيق Dart وتحليل Flutter واختبارات الوحدة والواجهات |

## تفعيل حماية الفروع

يجب تنفيذ هذه الخطوات في إعدادات المستودع على GitHub بعد دفع ملفات سير العمل وظهور فحص واحد ناجح على الأقل. أنشئ قاعدة حماية مستقلة لكل من `main` و`develop`، ثم فعّل طلب Pull Request قبل الدمج، وفحوص الحالة المطلوبة، وحل جميع المحادثات، ومنع force push والحذف. اختر حالة الفحص التالية بالاسم الكامل:

```text
Flutter CI / build
```

اختر الوضع الصارم إذا كان هدف الفريق هو إعادة تشغيل الفحص بعد كل تغيير يصل إلى الفرع الأساسي. لا تستخدم اسم وظيفة مكرراً في سير عمل آخر، حتى لا تصبح حالة الفحص المطلوبة ملتبسة.

> خطاف Git المحلي يحسن سرعة الملاحظات، لكنه لا يُعد حماية من الدمج. الحماية الملزمة تتحقق فقط في GitHub من خلال فحص الحالة المطلوب وقاعدة حماية الفرع.

## تشغيل تحقق الإصدار

لإنشاء artifact تجريبي، من تبويب **Actions** اختر `Release validation` ثم **Run workflow**. اترك خيار `run_integration_tests` مفعلاً لمرشح الإصدار. تنشئ المهمة artifact باسم يبدأ بـ `nostalgia-wing-android-` ويمكن تنزيله من صفحة التشغيل الناجح.

الملف الناتج مخصص للتحقق الداخلي فقط في الوضع الحالي، لأن `android/app/build.gradle` يوقّع بناء release بمفتاح debug. لا يجوز نشره إلى Google Play أو توزيعه بوصفه إصداراً إنتاجياً.

## الانتقال إلى نشر إنتاجي

قبل إضافة أي خطوة نشر تلقائي، جهز ما يلي:

| المتطلب | الإجراء |
|---|---|
| توقيع Android | إنشاء keystore إنتاجي خارج المستودع، وحفظه ومفاتيحه في GitHub Environment محمية أو خدمة أسرار مناسبة. |
| توقيع iOS | استخدام runner من macOS، وربط شهادات Apple وملفات provisioning بصورة آمنة. |
| الموافقات | إنشاء بيئة `production` في GitHub مع Required reviewers، وربط وظيفة النشر بها. |
| الصلاحيات | استخدام أقل صلاحيات Actions اللازمة وعدم تمرير أسرار النشر إلى Pull Requests. |
| التتبع | نشر artifact بعد نجاح التحقق وتسجيل الوسم وإصدار التطبيق في سجل الإصدار. |

لا تحفظ keystore أو كلمات مروره أو رموز المتاجر أو ملفات provisioning في Git أو في ملفات YAML. لا تستخدم `pull_request_target` لتشغيل كود يأتي من Pull Request غير موثوق مع أسرار متاحة.

## معايير القبول

يعد المسار جاهزاً للاعتماد عندما ينجح Pull Request سليم، ويفشل Pull Request يحتوي ملف Dart غير منسق أو خطأ تحليل أو اختبار فاشل، ويمنع GitHub الدمج في كل حالة فشل. كما يجب إنشاء artifact عند تشغيل تحقق الإصدار، مع التأكد من أن عدم وجود ملف AAB يؤدي إلى فشل صريح بدلاً من نجاح فارغ.

## مصادر

[1]: https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions "GitHub Actions workflow syntax"
[2]: https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches "GitHub protected branches"
[3]: https://github.com/marketplace/actions/flutter-action "Flutter action for GitHub Actions"
