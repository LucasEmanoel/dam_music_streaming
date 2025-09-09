
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  const InfoTile({
    super.key,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: hasImage
              ? DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
          color: hasImage ? null : Colors.grey[800],
        ),
        child: hasImage
            ? null
            : Center(
                child: SvgIcon(
                  assetName: 'assets/icons/Music.svg',
                  size: 30,
                  color: Colors.white,
                ),
              ),
      ),

      title: Text(title ?? ''),
      subtitle: Text(
        subtitle ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: EdgeInsets.only(left: 7),
      trailing: trailing,
      onTap: onTap,
      shape: null,
    );
  }
}
