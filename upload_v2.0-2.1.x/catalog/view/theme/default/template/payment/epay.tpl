<form name="SendOrder" method="post" action="<?php echo $action; ?>">
    <input type="hidden" name="Signed_Order_B64" value="<?php echo $request; ?>">
    <input type="hidden" name="email" value="<?php echo $email; ?>">
    <input type="hidden" name="Language" value="<?php echo $language; ?>">
    <input type="hidden" name="BackLink" value="<?php echo $backlink; ?>">
    <input type="hidden" name="PostLink" value="<?php echo $postlink; ?>">
    <div class="well well-sm">
        <?php if ($error_sign) { ?>
            <div class="text-danger"><?php echo $error_text_danger . ' (' . $error_sign . ')'?></div>
        <?php } ?>
        <p><?php echo $text_note; ?></p>
    </div>
    <div class="buttons">
        <div class="pull-right">
            <input type="submit" value="<?php echo $button_confirm; ?>" class="btn btn-primary" />
        </div>
    </div>
</form>