import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CancelledConsultationTab extends StatelessWidget {
  Map<String, dynamic> data;
  Widget buildBodyCancelled(String status) {
    // print('status =>$status');
    switch (status) {
      case 'CANCELED_BY_SYSTEM':
        return CancelledBody();
      case 'CANCELED_BY_USER':
        return CancelledBody();
      case 'CANCELED_BY_GP':
        return CancelledBody();
      case 'PAYMENT_EXPIRED':
        return ExpiredBody();
      case 'PAYMENT_FAILED':
        return ExpiredBody();
      case 'REFUNDED':
        return RefundedBody();
      default:
        return Container();
    }
  }

  CancelledConsultationTab({required this.data});
  @override
  Widget build(BuildContext context) {
    // print('data => $data');
    return buildBodyCancelled(
      data['status'].toString(),
    );
  }
}

class CancelledBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print('build cancelled!!!');
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        'Mohon maaf, jadwal konsultasi Anda dibatalkan. Silakan pilih jadwal ulang untuk konsultasi ',
        style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
      ),
    );
  }
}

class RefundedBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        'Proses refund Anda akan diproses maksimal 7 hari kerja. Silakan hubungi customer service AlteaCare untuk pertanyaan lebih lanjut',
        style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
      ),
    );
  }
}

class ExpiredBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mohon maaf, masa pembayaran Anda telah berakhir. Silakan pilih jadwal ulang untuk konsultasi ',
            style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Riwayat ini akan terhapus dalam 48 jam',
            style: kPoppinsMedium500.copyWith(color: kRedError, fontSize: 9),
          )
        ],
      ),
    );
  }
}
