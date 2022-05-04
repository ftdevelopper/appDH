import 'package:app_dos_hermanos/features/connect_bluetooth_feature/cubit/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/cubit/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/features/connect_bluetooth_feature/pages/discovery_page.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'filter_dialog.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget{
  const AppBarWidget({
    Key? key,
    required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Envios'),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        tabs: <Widget>[
          Tab(text: 'Todo', icon: Icon(Icons.home)),
          Tab(text: 'Nuevo', icon: Icon(Icons.fiber_new_outlined)),
          Tab(text: 'En Camino', icon: Icon(Icons.send)),
          Tab(text: 'Recibido', icon: Icon(Icons.call_received)),
          Tab(text: 'Conpletado', icon: Icon(Icons.done)),
          Tab(text: 'Eliminado', icon: Icon(Icons.delete_rounded))
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Image.asset(
            'assets/excel-3-24.png',
            scale: 1.1,
          ),
          onPressed: () {
            context
                .read<ShippingsBloc>()
                .add(CreateExcel());
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_alt_rounded),
          onPressed: () async {
            showDialog(context: context, builder: (context) => FilterDialog());
          },
        ),
        BlocBuilder<BluetoothCubit, MyBluetoothState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                Icons.bluetooth,
                color:
                    (state is ConnectedBluetooth) ? Colors.blue : Colors.grey,
              ),
              onPressed: () async {
                if (state is ConnectedBluetooth) {
                  context.read<BluetoothCubit>().disconectBluetooth();
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DiscoveryPage()));
                }
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2);
}