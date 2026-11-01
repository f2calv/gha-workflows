//! Prints its build version; CI uses it to exercise app-build-rust.yml.

fn describe(version: Option<&str>) -> String {
    match version {
        Some(v) if !v.is_empty() => format!("v{v}"),
        _ => "unversioned".to_string(),
    }
}

fn main() {
    println!("{}", describe(option_env!("VERSION")));
}

#[cfg(test)]
mod tests {
    use super::describe;

    #[test]
    fn describes_versions() {
        assert_eq!(describe(Some("1.2.3")), "v1.2.3");
        assert_eq!(describe(Some("")), "unversioned");
        assert_eq!(describe(None), "unversioned");
    }
}
