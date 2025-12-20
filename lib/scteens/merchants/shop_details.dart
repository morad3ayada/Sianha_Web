import 'package:flutter/material.dart';
import '/Total/TemporaryBanScreen.dart'; // الشاشة 1: الحظر المؤقت
import '/Total/PermanentBanScreen.dart'; // الشاشة 2: الحظر النهائي
import '/Total/MessageScreen.dart'; // الشاشة 3: إرسال رسالة
import '/Total/Tiypscreen.dart'; // الشاشة 4:  تعديل

class ShopDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> shop;
  ShopDetailsScreen({required this.shop});

  // دالة للاتصال بالرقم
  void _makePhoneCall(String phoneNumber) {
    // هنا كود الاتصال الهاتفي
    print("الاتصال بالرقم: $phoneNumber");
  }

  // دالة للذهاب لشاشة التعديل
  void _navigateToEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopDetails(), // افترضنا وجود هذه الشاشة
      ),
    );
  }

  // دالة للإضافة
  void _addNewItem(BuildContext context) {
    // هنا كود الإضافة
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم فتح شاشة الإضافة"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          shop["name"] ?? "تفاصيل المحل",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------------- صورة المحل ----------------
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                image: shop["image"] != null
                    ? DecorationImage(
                        image: NetworkImage(shop["image"]),
                        fit: BoxFit.cover,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: shop["image"] == null
                  ? Center(
                      child: Icon(Icons.storefront,
                          size: 80, color: Colors.blue[800]),
                    )
                  : null,
            ),
            SizedBox(height: 20),

            // ---------------- اسم وتخصص ----------------
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    shop["name"] ?? "اسم المحل",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    shop["type"] ?? "التخصص",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // ---------------- بطاقة البيانات ----------------
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 6,
              shadowColor: Colors.black26,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _infoRow(
                        Icons.phone, "الهاتف", shop["phone"] ?? "غير متوفر"),
                    _infoRow(Icons.check_circle, "الشغل المقبول",
                        "${shop["accepted"] ?? 0}"),
                    _infoRow(Icons.cancel, "الشغل المرفوض",
                        "${shop["rejected"] ?? 0}"),
                    _infoRow(Icons.location_on, "العنوان",
                        shop["address"] ?? "غير محدد"),
                    _infoRow(Icons.location_city, "المحافظة",
                        shop["governorate"] ?? "غير محددة"),
                    _infoRow(Icons.map, "المنطقة / المركز",
                        shop["center"] ?? "غير محددة"),
                    _infoRow(Icons.star, "التقييم",
                        "${shop["rate"] ?? "لا يوجد"} ⭐"),
                    _infoRow(Icons.local_offer, "الخصومات",
                        shop["discount"] ?? "لا توجد"),
                    _infoRow(Icons.card_giftcard, "المكافآت",
                        shop["rewards"] ?? "لا توجد"),
                    _infoRow(Icons.attach_money, "الأرباح",
                        "${shop["profit"] ?? 0}"),
                    _infoRow(Icons.access_time, "مواعيد العمل",
                        shop["hours"] ?? "غير محددة"),
                    _infoRow(Icons.toggle_on, "متاح/غير متاح",
                        shop["available"] ?? "متاح"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),

            // ---------------- أزرار الاتصال والرسالة ----------------
            Text(
              "الاتصال والتواصل",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.phone, size: 22),
                    label: Text(
                      "اتصال",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _makePhoneCall(shop["phone"] ?? "");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.message_rounded, size: 22),
                    label: Text(
                      "رسالة",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MessageScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),

            // ---------------- أزرار التعديل والإضافة ----------------
            Text(
              "إدارة المحل",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit, size: 22),
                    label: Text(
                      "تعديل",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _navigateToEditScreen(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add_circle, size: 22),
                    label: Text(
                      "إضافة",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _addNewItem(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            // ---------------- أزرار الحظر ----------------
            Text(
              "إجراءات الحظر",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.pause_circle_outline, size: 22),
                    label: Text(
                      "حظر مؤقت",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TemporaryBanScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.block, size: 22),
                    label: Text(
                      "حظر نهائي",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PermanentBanScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // ---------------- زر إضافي للعودة ----------------
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  foregroundColor: Colors.grey[700],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "العودة للخلف",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue[900], size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "$title:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
