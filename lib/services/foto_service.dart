import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

class ImageUploadService {
  static Future<String?> pickAndUploadImage(String userId) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) return null;

  final file = File(pickedFile.path);
  final fileExt = extension(file.path);
  final fileName = 'avatar_$userId$fileExt';
  final filePath = 'avatars/$userId/$fileName';

  try {
    final supabase = Supabase.instance.client;

    // Remove imagem antiga, se existir (opcional)
    final existing = await supabase.storage.from('avatars').list(path: 'avatars/$userId');
    for (final item in existing) {
      await supabase.storage.from('avatars').remove(['avatars/$userId/${item.name}']);
    }

    // Faz o upload
    await supabase.storage.from('avatars').upload(
          filePath,
          file,
          fileOptions: FileOptions(
            contentType: 'image/${fileExt.replaceAll('.', '')}',
            upsert: true,
          ),
        );

    // Retorna a URL pública
    final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
    return publicUrl;
  } catch (e) {
    print('Erro no upload: $e');
    return null;
  }
}

static Future<String?> carregarFotoDePerfil(String userId) async {
  try {
    final supabase = Supabase.instance.client;

    // Caminho fixo da imagem com extensão presumida (ajuste conforme o padrão que você usar no upload)
    final List<String> possiveisExtencoes = ['.jpg', '.jpeg', '.png', '.webp'];

    for (final ext in possiveisExtencoes) {
      final path = 'avatars/$userId/avatar_$userId$ext';
      final response = await supabase.storage.from('avatars').list(path: 'avatars/$userId');

      final existe = response.any((item) => item.name == 'avatar_$userId$ext');
      if (existe) {
        final publicUrl = supabase.storage.from('avatars').getPublicUrl(path);
        return publicUrl;
      }
    }

    // Se nenhuma imagem encontrada
    return null;
  } catch (e) {
    print('Erro ao carregar imagem de perfil: $e');
    return null;
  }
}

}
