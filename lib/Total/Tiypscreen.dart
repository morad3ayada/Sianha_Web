import 'package:flutter/material.dart';

class ShopDetails extends StatefulWidget {
  final Map<String, dynamic>? technician; // جعله اختياري

  ShopDetails({this.technician}); // جعله اختياري

  @override
  _EditShopScreenState createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<ShopDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController governorateController = TextEditingController();
  TextEditingController centerController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController rewardsController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  void saveChanges() {
    Map updatedShop = {
      "name": nameController.text,
      "type": typeController.text,
      "phone": phoneController.text,
      "governorate": governorateController.text,
      "center": centerController.text,
      "address": addressController.text,
      "hours": hoursController.text,
      "rate": rateController.text,
      "rewards": rewardsController.text,
      "discount": discountController.text,
    };

    Navigator.pop(context, updatedShop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تعديل بيانات المحل"),
        backgroundColor: Colors.orange[700],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _textField("اسم المحل", nameController),
            _textField("التخصص", typeController),
            _textField("الهاتف", phoneController),
            _textField("المحافظة", governorateController),
            _textField("المركز", centerController),
            _textField("العنوان", addressController),
            _textField("مواعيد العمل", hoursController),
            _textField("التقييم", rateController),
            _textField("المكافآت", rewardsController),
            _textField("الخصومات", discountController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
              ),
              child: Text(
                "حفظ التغييرات",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
