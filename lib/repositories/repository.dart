abstract class Repository<T, K> {
  T get(K id);
  List<T> getAll();
  T create(T obj);
  T update(T obj);
  void delete(T obj);
}
