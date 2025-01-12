
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotas/Validations.dart';

void main(){
  final Validations _validations = Validations();

  //VALIDATIONS USERNAME
  test('Valid username', () async{
     String? result =  _validations.validateUser("sjpozo1");
      expect(result, null);
    }
  );

  //Can't be less than 5 letters and numbers
  test("Invalid username", () async{
      String? result = _validations.validateUser("Lu1");
      expect(result, isNotNull);
    }
  );

  test("Invalid username", () async{
      String? result = _validations.validateUser("");
      expect(result, isNotNull);
    }
  );

  //Can't be more than 10 letters and numbers
  test("Invalid username", () async{
      String? result = _validations.validateUser("kokusHameHameHaa");
      expect(result, isNotNull);
    }
  );

  //Can't have special characters
  test("Invalid username", () async{
      String? result = _validations.validateUser("sjpozo1#.");
      expect(result, isNotNull);
    }
  );


  //VALID PERSON NAME
  test("Valid Name", () async{
      String? result = _validations.validateName("Steven");
      expect(result, null);
    }
  );

  test("Valid Name", () async{
      String? result = _validations.validateName("Luz");
      expect(result, null);
    }
  );
  test("Valid Name", () async{
      String? result = _validations.validateName("Guillermo");
      expect(result, null);
    }
  );
  test("Valid Name", () async{
      String? result = _validations.validateName("Sebastián");
      expect(result, null);
    }
  );

  test("Valid Name", () async{
    String? result = _validations.validateName("Guillermo Sebastian");
    expect(result, null);
  }
  );

  //Must have the first letter capitalized
  test("Invalid Name", () async{
      String? result = _validations.validateName("steven");
      expect(result, isNotNull);
    }
  );

  test("Invalid Name", () async{
      String? result = _validations.validateName("");
      expect(result, isNotNull);
    }
  );

  //Can't have less than 2 lettres
  test("Invalid Name", () async{
      String? result = _validations.validateName("L");
      expect(result, isNotNull);
    }
  );

  //Can't have numbers
  test("Invalid Name", () async{
      String? result = _validations.validateName("Steven1234");
      expect(result, isNotNull);
    }
  );


  //VALIDATE PASSWORD
  test("Valid Password", () async{
      String? result = _validations.validatePassword("dcdsd121##2");
      expect(result, null);
    }
  );
  test("Valid Password", () async{
      String? result = _validations.validatePassword("sjpo1223##.'");
      expect(result, null);
    }
  );

  //Can't less than 6 characteres
  test("Invalid Password", () async{
      String? result = _validations.validatePassword("12sa");
      expect(result, isNotNull);
    }
  );

  test("Invalid Password", () async{
    String? result = _validations.validatePassword("");
    expect(result, isNotNull);
  }
  );


  //VALIDATE EQUALS PASSWORD
  test("Valid Equals Password", () async{
      String? result = _validations.validatePasswordEquals("sjpozo1234", "sjpozo1234");
      expect(result, null);
    }
  );

  test("Invalid Equals Password", () async{
      String? result = _validations.validatePasswordEquals("sjpozo1234", "sjpozo4321");
      expect(result, isNotNull);
    }
  );
  
  
  
  
  //VALIDATE EMAILS
  test("Valid Email", () async{
      String? result = _validations.validateEmail("stevenpozo0999@gmail.com");
      expect(result, null);
    }
  );

  //Must have @example.com
    test("Valid Email", () async{
      String? result = _validations.validateEmail("stevenpozo0999");
      expect(result, isNotNull);
    }
  );

  //Can't have # before @example.com
  test("Invalid Email", () async{
      String? result = _validations.validateEmail("steven#0999@gmail.com");
      expect(result, isNotNull);
    }
  );

  test("Invalid Email", () async{
      String? result = _validations.validateEmail("");
      expect(result, isNotNull);
    }
  );
  //Can't start with a number
  test("Invalid Email", () async{
      String? result = _validations.validateEmail("111steven0999@gmail.com");
      expect(result, isNotNull);
    }
  );


  //VALIDATE PHONE NUMBER ECUTORIAN
  test("Valid Phone Number", () async{
      String? result = _validations.validatePhoneNumber("0981515127");
      expect(result, null);
    }
  );

  //Can't have less than 10 numbers
  test("Invalid Phone Number", () async{
      String? result = _validations.validatePhoneNumber("098151512");
      expect(result, isNotNull);
    }
  );

  //Can't have letters
  test("Invalid Phone Number", () async{
      String? result = _validations.validatePhoneNumber("numerouwu");
      expect(result, isNotNull);
    }
  );

  //Can't have more than 10 numbers
  test("Invalid Phone Number", () async{
      String? result = _validations.validatePhoneNumber("09815151277");
      expect(result, isNotNull);
    }
  );

  test("Invalid Phone Number", () async{
    String? result = _validations.validatePhoneNumber("");
    expect(result, isNotNull);
  }
  );

  //Must start with 09
  test("Invalid Phone Number", () async{
    String? result = _validations.validatePhoneNumber("9981515127");
    expect(result, isNotNull);
  }
  );
}