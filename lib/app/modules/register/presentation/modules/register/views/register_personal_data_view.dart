// Flutter imports:
// Project imports:
import 'package:altea/app/core/widgets/custom_dropdown_field.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RegisterPersonalDataView extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const RegisterPersonalDataView({required this.formKey});

  @override
  _RegisterPersonalDataViewState createState() => _RegisterPersonalDataViewState();
}

class _RegisterPersonalDataViewState extends State<RegisterPersonalDataView> {
  List<String> nation = ['Indonesia', 'Malaysia', 'Singapura', 'Amerika', 'Filipina'];

  String? selectedNationName = '';

  List<String> genders = ['Laki Laki', 'Perempuan'];
  String? selectedGender = null;

  RegisterController controller = Get.put(RegisterController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.dataSaved.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.isMobile) {
        return Form(
          key: widget.formKey,
          child: Column(
            children: [
              CustomTextField(
                textCapitalization: TextCapitalization.words,
                onChanged: (val) {},
                validator: (val) {
                  if (val == '') {
                    return 'Nama depan belum terisi';
                  }
                  if ((val?.length ?? 2) < 4) {
                    return 'Nama harus 3 karakter atau lebih';
                  }
                },
                onSaved: (val) {
                  // print('save nih');
                  if (val != null) {
                    controller.firstName.value = val;
                  }
                },
                hintText: 'Nama Depan',
                keyboardType: TextInputType.text,
              ),
              CustomTextField(
                textCapitalization: TextCapitalization.words,
                onChanged: (val) {},
                validator: (val) {
                  if (val == '') {
                    return 'Nama Belakang belum terisi';
                  }
                  if ((val?.length ?? 2) < 4) {
                    return 'Nama belakang harus 3 karakter atau lebih';
                  }
                },
                onSaved: (val) {
                  // print('save nih');
                  if (val != null) {
                    controller.lastName.value = val;
                  }
                },
                hintText: 'Nama Belakang',
                keyboardType: TextInputType.text,
              ),
              CustomTextField(
                onChanged: (val) {},
                validator: (val) {
                  if (val == '') {
                    return 'Tanggal Lahir belum terisi';
                  }
                },
                onSaved: (val) {
                  // print('save nih');
                  if (val != null) {
                    controller.birthDate.value = val;
                  }
                },
                hintText: 'Tanggal Lahir',
                keyboardType: TextInputType.datetime,
              ),
              // CustomTextField(
              //   textCapitalization: TextCapitalization.words,
              //   onChanged: (val) {},
              //   validator: (val) {
              //     if (val!.isEmpty) {
              //       return 'No. KTP Belum diisi';
              //     } else if (val.length != 16) {
              //       return 'No. KTP harus 16 digit';
              //     } else {
              //       return null;
              //     }
              //   },
              //   onSaved: (val) {
              //     // print('save nih');
              //     if (val != null) {
              //       controller.ktpNo.value = val;
              //     }
              //   },
              //   hintText: 'Nomor KTP',
              //   keyboardType: TextInputType.number,
              //   inputFormatters: [
              //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              //     LengthLimitingTextInputFormatter(16),
              //   ],
              // ),
              FutureBuilder(
                  future: controller.getCountry(),
                  builder: (context, snapshot) {
                    List<dynamic> nations = [];
                    if (snapshot.hasData) {
                      nations = snapshot.data! as List<dynamic>;
                      for (final item in nations) {
                        if (item["code"] == "ID") {
                          controller.selectedNation.value = item["country_id"].toString();
                        }
                      }
                    }
                    return CustomDropdownField(
                      onSaved: (val) {
                        if (val != null) {
                          controller.nation.value = val.toString();
                        }
                      },
                      validator: (val) {
                        if (val == null) {
                          return 'Negara Belum dipilih';
                        }
                      },
                      items: nations.map((e) => DropdownMenuItem(value: e['country_id'], child: Text(e['name'].toString()))).toList(),
                      onChanged: (val) {
                        setState(() {
                          controller.selectedNation.value = val.toString();
                        });
                        controller.countryName.value =
                            nations.where((element) => element['country_id'] == controller.selectedNation.value).toList()[0]['name'].toString();

                        // print('country name => ${controller.countryName}');
                      },
                      hintText: 'Negara',
                      value: controller.selectedNation.value.isEmpty ? null : controller.selectedNation.value,
                    );
                  }),
              CustomTextField(
                  onChanged: (val) {},
                  validator: (val) {
                    if (val == '') {
                      return 'Kota Kelahiran belum terisi';
                    }
                  },
                  onSaved: (val) {
                    // print('save nih');
                    if (val != null) {
                      controller.birthTown.value = val;
                    }
                  },
                  hintText: 'Kota Kelahiran',
                  keyboardType: TextInputType.text),
              CustomDropdownField(
                onSaved: (val) {
                  if (val != null) {
                    controller.gender.value = val.toString();
                  }
                },
                validator: (val) {
                  if (val == null) {
                    return 'Jenis Kelamin belum dipilih';
                  }
                },
                items: genders.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedGender = val.toString();
                  });
                },
                hintText: 'Jenis Kelamin',
                value: selectedGender,
              ),
            ],
          ),
        );
      } else {
        return Form(
          key: widget.formKey,
          child: Column(
            children: [
              CustomTextField(
                  onChanged: (val) {},
                  validator: (val) {
                    if (val == '') {
                      return 'Nama depan belum terisi';
                    }
                  },
                  onSaved: (val) {
                    // print('save nih');
                    if (val != null) {
                      controller.firstName.value = val;
                    }
                  },
                  hintText: 'Nama Depan',
                  keyboardType: TextInputType.text),
              CustomTextField(
                  onChanged: (val) {},
                  validator: (val) {
                    if (val == '') {
                      return 'Nama Belakang belum terisi';
                    }
                  },
                  onSaved: (val) {
                    // print('save nih');
                    if (val != null) {
                      controller.lastName.value = val;
                    }
                  },
                  hintText: 'Nama Belakang',
                  keyboardType: TextInputType.text),
              CustomTextField(
                  onChanged: (val) {},
                  validator: (val) {
                    if (val == '') {
                      return 'Tanggal Lahir belum terisi';
                    }
                  },
                  onSaved: (val) {
                    // print('save nih');
                    if (val != null) {
                      controller.birthDate.value = val;
                    }
                  },
                  hintText: 'Tanggal Lahir',
                  keyboardType: TextInputType.datetime),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder(
                  future: controller.getCountry(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      controller.nations.value = snapshot.data! as List<dynamic>;
                      for (final item in controller.nations) {
                        if (item["code"] == "ID") {
                          controller.selectedNation.value = item["country_id"].toString();
                          controller.countryName.value = item["name"].toString();
                        }
                      }
                      return Obx(() => CustomDropdownField(
                            onSaved: (val) {
                              if (val != null) {
                                controller.nation.value = val.toString();
                              }
                            },
                            validator: (val) {
                              if (val == null) {
                                return 'Negara Belum dipilih';
                              }
                            },
                            items:
                                controller.nations.map((e) => DropdownMenuItem(value: e['country_id'], child: Text(e['name'].toString()))).toList(),
                            onChanged: (val) {
                              controller.selectedNation.value = val.toString();
                              controller.countryName.value = controller.nations
                                  .where((element) => element['country_id'] == controller.selectedNation.value)
                                  .toList()[0]['name']
                                  .toString();

                              // print('country name => ${controller.countryName}');
                            },
                            hintText: 'Negara',
                            value: controller.selectedNation.value.isEmpty ? null : controller.selectedNation.value,
                          ));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              const SizedBox(
                height: 8,
              ),
              CustomTextField(
                  onChanged: (val) {},
                  validator: (val) {
                    if (val == '') {
                      return 'Kota Kelahiran belum terisi';
                    }
                  },
                  onSaved: (val) {
                    // print('save nih');
                    if (val != null) {
                      controller.birthTown.value = val;
                    }
                  },
                  hintText: 'Kota Kelahiran',
                  keyboardType: TextInputType.text),
              const SizedBox(
                height: 8,
              ),
              CustomDropdownField(
                onSaved: (val) {
                  if (val != null) {
                    controller.gender.value = val.toString();
                  }
                },
                validator: (val) {
                  if (val == null) {
                    return 'Jenis Kelamin belum dipilih';
                  }
                },
                items: genders.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedGender = val.toString();
                  });
                },
                hintText: 'Jenis Kelamin',
                value: selectedGender,
              ),
            ],
          ),
        );
      }
    });
  }
}
