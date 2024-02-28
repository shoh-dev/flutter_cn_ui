/// 0. Components can be found in: lib/components (or the folder specified in fcnui.json)
import 'package:example/components/button.dart';
import 'package:example/components/card.dart';
import 'package:example/components/checkbox.dart';
import 'package:example/components/dropdown.dart';
import 'package:example/components/form.dart';
import 'package:example/components/input.dart';
import 'package:example/components/save_button.dart';
import 'package:example/components/with_label.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'components/dp_item.dart';

void main() {
  /// 1. Wrap your app with [DefaultStoreProvider]
  runApp(DefaultStoreProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /// 2. Use fcnui components ex:[DefaultButton]
              DefaultButton(
                variant: PrimaryButtonVariant(
                  onPressed: () {
                    ChangeFlexSchemeAction(flexScheme: FlexScheme.wasabi.name)
                        .payload();
                  },
                  text: "Increment",
                  icon: Icons.add,
                ),
              ),

              const DefaultCard(
                variant: CardVariant(
                    title: CardTitle(title: "Hello"),
                    content: CardContent(content: Text("Context")),
                    footer: CardFooter(footer: [])),
              ),

              _DecoratedCard(),

              const _WithLabel(),

              const _Search(),
            ],
          ).spaced(20),
        ),
      ),
    );
  }
}

class _WithLabel extends StatelessWidget {
  const _WithLabel();

  @override
  Widget build(BuildContext context) {
    return const FormCheckbox(
      vm: CheckboxModel(
        name: "withLabel",
        items: [
          DpItem(
              id: "1",
              title: "Accept terms and conditions",
              subtitle:
                  "You agree to our Terms of Service and Privacy Policy."),
        ],
      ),
    );
  }
}

class _DecoratedCard extends StatelessWidget {
  _DecoratedCard();

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, vm) {
      final colorScheme = vm.theme.colorScheme;
      return DefaultCard(
        decoration: CardDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: colorScheme.primaryContainer,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside),
          color: colorScheme.primaryContainer.withOpacity(0.2),
        ),
        variant: CardVariant(
          title: const CardTitle(title: "Create project"),
          subtitle: const CardSubtitle(
              subtitle: "Deploy your new project in one-click"),
          content: CardContent(
            content: DefaultForm(
              vm: formModel,
              child: Column(
                children: [
                  WithLabel(
                    labelVm: const LabelModel(text: "Name"),
                    child: DefaultInput(
                      vm: InputModel(
                        name: "name",
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                        hintText: "Name of the project",
                      ),
                    ),
                  ),
                  const WithLabel(
                    labelVm: LabelModel(text: "Description"),
                    child: DefaultInput(
                      vm: InputModel(
                        name: "description",
                        hintText: "Description of the project",
                      ),
                    ),
                  ),
                ],
              ).spaced(20),
            ),
          ),
          footer: CardFooter(
            footer: [
              DefaultButton(
                variant: OutlineButtonVariant(
                  onPressed: () {},
                  text: "Cancel",
                ),
              ),
              SaveButton(
                  vm: formModel,
                  text: "Deploy",
                  onSave: (value) {
                    if (formModel.isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(formModel.getValues().toString())));
                    }
                  })
            ],
          ),
        ),
      );
    });
  }
}

class _Search extends StatelessWidget {
  const _Search();

  final _items = const [
    DropdownItem(items: [
      DpItem(title: "Australia", id: "aus"),
      DpItem(title: "Bangladesh", id: "bng"),
      DpItem(title: "UK", id: "uk"),
      DpItem(title: "USA", id: "usa"),
      DpItem(title: "Uzbekistan", id: "uzb"),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "Search"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                decoration: const DpDecoration(
                  hintText: "Select a country",
                  hasSearchBox: true,
                ),
                form: DpForm(
                    items: _items
                        .map((e) => e.copyWith(
                            items: e.items
                                .map((e) => e.copyWith(icon: Icons.flag))
                                .toList()))
                        .toList(),
                    onChanged: (p0) {}))));
  }
}
