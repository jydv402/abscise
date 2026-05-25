import 'media_item.dart';

class SwipedItem {
  final MediaItem item;
  final bool
  isDeleted; // true = swiped left (Delete/Bin), false = swiped right (Keep)

  SwipedItem({required this.item, required this.isDeleted});
}
