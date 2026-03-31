import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class ButtonCompany extends StatefulWidget {
  const ButtonCompany({super.key});

  @override
  State<ButtonCompany> createState() => _ButtonCompanyState();
}

class _ButtonCompanyState extends State<ButtonCompany> {
  bool isCompanySelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 42, left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            obscureText: false,
            readOnly: !isCompanySelected,
            decoration: InputDecoration(
              hintText: 'I Working for a Company',
              hintStyle: AppTextStyle.regularPoppins20.copyWith(
                color: Colors.grey,
                fontSize: 15,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: (){
                    setState(() {
                      isCompanySelected = !isCompanySelected;
                      });
                    },
                    icon: Icon(
                      isCompanySelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isCompanySelected ? Colors.green : Colors.grey,
                      size: 35,
                  ),
                ), 
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: accent, width: 2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3, left: 20),
            child: Text(
              'Optional: for company members only',
              style: AppTextStyle.regularPoppins10.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
