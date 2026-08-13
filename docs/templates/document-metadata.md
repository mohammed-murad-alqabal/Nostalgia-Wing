# قالب metadata للوثائق



انسخ الرأس التالي إلى بداية أي وثيقة حاكمة، ثم املأ القيم بدقة. لا تستخدم `Current` دون commit تحقق.



```markdown

> **Status:** Current | Proposed | Partial | Deprecated | Archived

> **Owner:** اسم الفريق أو المسؤول

> **Authority:** Code | Test | Requirement | ADR | Spec | History

> **Last verified:** YYYY-MM-DD

> **Verified commit:** `full-or-short-commit`

> **Related code:** `path/to/code`

> **Related tests:** `path/to/test`

> **Supersedes:** `path/to/old-document` أو `None`

> **Superseded by:** `path/to/new-document` أو `None`

> **إعداد:** إعداد فريق تطوير مشروع جناح الحنين

```



## قواعد الاستخدام



تستخدم `Current` لوصف واقع مثبت في الكود والاختبارات، وتستخدم `Proposed` للتصميم الذي لم يدخل الإنتاج أو لم يكتمل تنفيذه. إذا كان التنفيذ جزئياً، فاستخدم `Partial` واشرح النقص. الوثائق التاريخية تستخدم `Archived` ولا تظهر في خريطة الحالة الحالية.

