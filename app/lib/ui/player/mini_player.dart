import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/song_data.dart';
import 'player_view_model.dart';

class MiniPlayer extends StatelessWidget {
  final VoidCallback? onOpenFullPlayer;
  const MiniPlayer({super.key, this.onOpenFullPlayer});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (_, vm, __) {
        final s = vm.current;
        final show = vm.hasTrack;
        final progress = (vm.duration.inMilliseconds == 0)
            ? 0.0
            : vm.position.inMilliseconds / vm.duration.inMilliseconds;

        return AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          offset: show ? Offset.zero : const Offset(0, 1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: show ? 1 : 0,
            child: Material(
              elevation: 8,
              color: Theme.of(context).colorScheme.surface,
              child: InkWell(
                onTap: onOpenFullPlayer,
                child: SizedBox(
                  height: 64 + 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              // capa
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: s?.urlCover != null && s!.urlCover!.isNotEmpty
                                    ? Image.network(s.urlCover!, width: 44, height: 44, fit: BoxFit.cover)
                                    : Container(width: 44, height: 44, color: Colors.grey[400]),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s?.title ?? '—',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      s?.artist?.name ?? '—',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(vm.isPlaying ? Icons.pause : Icons.play_arrow),
                                onPressed: vm.toggle,
                              ),
                              IconButton(
                                icon: const Icon(Icons.skip_next),
                                onPressed: vm.next,
                              ),
                            ],
                          ),
                        ),
                      ),
                      LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
