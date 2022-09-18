abstract class GenericRepository<T> {
  Future<List<T>> getAll();
}
