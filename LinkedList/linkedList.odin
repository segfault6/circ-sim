package LinkedList

Node :: struct($T: typeid) {
    prev: ^Node(T),
    data: T,
    next: ^Node(T),
}

List :: struct($T: typeid) {
    head: ^Node(T),
    tail: ^Node(T),
    length: u32
}

prepend :: proc(list: ^List($T), data: T) {
    node : ^Node(T) = new(Node(T))
    node.data = data
    node.prev = nil

    if list.head == nil {
        list.head = node
        list.tail = list.head
    } else {
        node.next = list.head
        list.head.prev = node
        list.head = node
    }

    list.length += 1
}

append :: proc(list: ^List($T), data: T) {
    node : ^Node(T) = new(Node(T))
    node.data = data
    node.next = nil

    if list.head == nil {
        node.prev = nil
        list.head = node
        list.tail = list.head
    } else {
        node.prev = list.tail
        list.tail.next = node
        list.tail = node
    }
}

destroy :: proc(list: ^List($T), data: T) {
    node : ^Node(T) = list.head
    for node != nil {
        next : ^Node(T) = node.next
        free(node)
        node = next
    }
    list.head = nil
    list.tail = nil
}
