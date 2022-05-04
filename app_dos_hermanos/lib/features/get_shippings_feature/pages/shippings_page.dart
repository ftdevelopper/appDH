import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_dos_hermanos/features/add_new_shipping_feature/cubit/new_shipping_cubit/new_shipping_cubit.dart';
import 'package:app_dos_hermanos/features/add_new_shipping_feature/pages/new_shipping.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/cubit/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import '../../../repositories/authentication_repository.dart';
import '../../../repositories/local_data_base.dart';
import '../cubit/drawer_bloc/drawer_bloc.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/drawer.dart';
import '../widgets/shipping_list_widget.dart';

class ShippingsPage extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;
  final LocalDataBase localDataBase;

  ShippingsPage(
      {Key? key,
      required this.authenticationRepository,
      required this.localDataBase})
      : super(key: key);

  @override
  _ShippingsPageState createState() => _ShippingsPageState();
}

class _ShippingsPageState extends State<ShippingsPage>
    with SingleTickerProviderStateMixin {
  List<Shipping> shippingList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBarWidget(tabController: _tabController),
        body: BlocBuilder<ShippingsBloc, ShippingsState>(
            builder: (context, state) {
          if (state is ShippingsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ShippingsNotLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.error),
                  Text('No se pudieron cargar los envios'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ShippingsBloc>().add(LoadShippings());
                    },
                    child: Text('Recargar'),
                  ),
                ],
              ),
            );
          }
          if (state is ShippingsLoaded) {
            shippingList = state.shippings;
            return TabBarView(
              controller: _tabController,
              children: <Widget>[
                ShippingsListWidget(
                  shippingList: shippingList,
                  status: [
                    ShippingStatus.newShipping,
                    ShippingStatus.inTravelShipping,
                    ShippingStatus.downloadedShipping,
                    ShippingStatus.completedShipping,
                  ],
                ),
                ShippingsListWidget(
                  shippingList: shippingList,
                  status: [ShippingStatus.newShipping],
                ),
                ShippingsListWidget(
                  shippingList: shippingList,
                  status: [ShippingStatus.inTravelShipping],
                ),
                ShippingsListWidget(
                  shippingList: shippingList,
                  status: [ShippingStatus.downloadedShipping],
                ),
                ShippingsListWidget(
                  shippingList: shippingList,
                  status: [ShippingStatus.completedShipping],
                ),
                ShippingsListWidget(
                  shippingList: shippingList,
                  status: [ShippingStatus.deletedShipping],
                ),
              ],
            );
          } else {
            return Container();
          }
        }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_box_outlined),
          onPressed: () {
            if (_tabController.index <= 1) {
              context.read<NewShippingCubit>().setNewShipping();
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => NewShipping()),
              );
            }
          },
          tooltip: 'Nuevo Envio',
        ),
        drawer: BlocBuilder<DrawerBloc, DrawerState>(
          builder: (context, state) {
            if (state is LoadingDrawer) {
              return Drawer(
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return LoadedDrawer(
                  user: context.read<AuthenticationRepository>().user);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
