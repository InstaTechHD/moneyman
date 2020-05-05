abstract class Repository<T, K> {
  Future<T> get(K id);
  Future<List<T>> getAll();
  Future<K> create(T obj);
  Future update(T obj);
  Future delete(T obj);
}
