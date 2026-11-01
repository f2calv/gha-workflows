from fixture import describe


def test_describe() -> None:
    assert describe("1.2.3") == "v1.2.3"
    assert describe("") == "unversioned"
    assert describe(None) == "unversioned"
