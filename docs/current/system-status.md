# حالة النظام الحالية



> **Status:** Current
> 
> **Owner:** فريق التطوير
> 
> **Authority:** Code + Dependencies + Tests
> 
> **Last verified:** 13 أغسطس 2026
> 
> **Verified commit:** `868efdf`
> 
> **Related code:** `active_source_wing/lib/`, `active_source_wing/pubspec.yaml`
> 
> **Related tests:** `active_source_wing/test/`
> 
> **إعداد:** إعداد فريق تطوير مشروع جناح الحنين
> 


## ملخص الحالة



المشروع تطبيق Flutter/Dart محلي-first، ويحتوي على واجهات وتجارب للذكريات والرسائل والمفاجآت والتحليل النفسي/العاطفي. هذه الوثيقة تصف ما يمكن إثباته من المستودع، ولا تعتبر التصاميم المستقبلية دليلاً على التنفيذ.



| المجال | الحالة الحالية | الدليل |

|---|---|---|

| منصة التطبيق | منفذ | `active_source_wing/pubspec.yaml` وملفات المنصة |

| إدارة الاعتماديات | Provider | `active_source_wing/lib/main.dart` يستخدم `MultiProvider` و`Provider` |

| التخزين المحلي | Drift وHive | `active_source_wing/lib/core/data/app_database.dart` وتهيئة Hive |

| الأمان المحلي | Secure Storage وCryptography | `active_source_wing/lib/core/security/` |

| المحركات النفسية/المعرفية | منفذة جزئياً/فعلياً حسب الوحدة | `active_source_wing/lib/core/cognitive/` و`core/psychology/` |

| Backend عام | غير مثبت في هذا المستودع | لا يوجد مسار Backend تشغيلي معتمد |

| PostgreSQL/FastAPI | مقترح | لا تظهر خدمة تشغيلية مطابقة في الكود الحالي |

| Signal Protocol وE2EE | غير مثبت | تشفير محلي لا يساوي تشفيراً طرفياً بين مستخدمين |

| LLM محلي Gemma/Llama | مقترح | لا توجد تبعية أو نموذج أو قناة تشغيل واضحة |

| TensorFlow Lite/MediaPipe | مقترح | لا توجد تبعيات تنفيذية مطابقة |

| التوصيات الذكية المتقدمة | مواصفة/مقترح | لا يوجد محرك توصيات مطابق موثق كتنفيذ حالي |



## قواعد القراءة



وجود اسم تقنية في وثيقة أو تعليق لا يغير هذه الحالة. لكي تنتقل ميزة من `Proposed` إلى `Current` يجب أن يوجد مسار كود، وتبعيات معلنة، واختبار أو فحص قابل للتكرار، ونتيجة تحقق مرتبطة بcommit.



## حدود التحقق



لم تُشغّل أوامر Flutter في بيئة إنشاء هذه الوثيقة إذا لم تكن أداة Flutter متاحة. لذلك يجب عدم تحويل أي ادعاء تاريخي عن نجاح الاختبارات إلى نتيجة حالية دون artifact صادر عن CI.



## التحديث



عند كل إصدار أو تغيير معماري، حدّث `Last verified` و`Verified commit` وجدول الحالة، وأضف أو حدّث ADR عند تغيير مصدر تقنية أو نمط معماري.









