import 'package:flutter/material.dart';

class AsyncWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final Widget Function()? loading;
  final Widget Function()? error;
  final Widget Function(BuildContext context, AsyncSnapshot snapshot) builder;
  const AsyncWidget({required this.snapshot,required this.builder,this.error,this.loading, super.key});

  @override
  Widget build(BuildContext context) {
    if(snapshot.hasError){
      return error == null ? const Text("Loi roi"): error!();
    }
    if(!snapshot.hasData){
      return loading == null ? const Center(child: CircularProgressIndicator(),): loading!();
    }
    return builder(context,snapshot);
  }


}

