import 'package:flutter/material.dart';

class TodoCard extends StatefulWidget {
  const TodoCard(
      {super.key,
      required this.title,
      required this.iconData,
      required this.iconColor,
      required this.time,
      required this.check,
      required this.iconBgColor,
      required this.onChange,
      required this.index});

  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool check;
  final Color iconBgColor;
  final Function onChange;
  final int index;
  

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            data: ThemeData(
                primarySwatch: Colors.blue,
                unselectedWidgetColor: Colors.amber),
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                activeColor: const Color(0xff6cf8a9),
                checkColor: const Color(0xff0e3e26),
                value: widget.check,
                onChanged: (bool? change) {
                  widget.onChange(widget.index);
                },
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: const Color(0xff2a2e3d),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color: widget.iconBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.iconData,
                        color: widget.iconColor,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 18,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    
                    Text(
                      widget.time,
                      style: const TextStyle(
                          fontSize: 13,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                 
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
