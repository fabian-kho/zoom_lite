import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({Key? key, required this.title, required this.thumbnail, required this.onTap})
      : super(key: key);
  final String title;
  final VoidCallback onTap;
  final Image thumbnail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        // add padding
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        onTap: onTap,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
        // leading thumbnail
        leading: SizedBox(
          width: 90,
          height: 60,
          // set border radius
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            // set image to thumbnailPath
            child: thumbnail,
          ),
        ),
      ),
    );
  }
}
